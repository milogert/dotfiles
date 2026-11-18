#!/usr/bin/env sh

# Fail immediately on errors.
set -e -u -o pipefail

if [[ ${1:-''} == '--help' ]]; then
  echo "./add_user.sh [host] [username] [headless/desktop] [macos/linux]"
  exit 0
fi

# require_arg -> (target, prompt, yes/no) -> void
require_arg() {
  declare -n target="$1"
  local prompt="$2"
  local yes_no="${3:-}"

  if [[ $yes_no == 1 ]]; then
    while [[ ! "$target" =~ ^(y|n)$ ]]; do
      read -rp "$prompt" target
    done
  else
    while [[ -z "$target" ]]; do
      read -rp "$prompt" target
    done
  fi
}

echo "Adding a user..."

host="${1:-}"
username="${2:-}"
is_headless="${3:-}"
is_mac_os="${4:-}"

require_arg host "host: "

if [[ ! -e "./hosts/${host}" ]]; then
  echo "Host ${host} doesn't exist."
  exit 1
fi

require_arg username "username: "
require_arg is_headless "headless [y/n]: " 1
require_arg is_mac_os "macos [y/n]: " 1

if [[ -z "$username" ]]; then
  read -rp "username: " username
fi

if [[ -z "$is_headless" ]]; then
  read -rp "headless [y/n]: " is_headless
fi

if [[ -z "$is_mac_os" ]]; then
  read -rp "macos [y/n]: " is_mac_os
fi

echo "Adding ${username} to ${host}"

common_user_path="./hosts/_common/users/${username}/default.nix"

prefix=$(cat << EOF
# Generated on $(date) for ${username} by $(whoami) on $(hostname)
{
  config,
  pkgs,
  ...
}:

EOF
)

if [ -f ${common_user_path} ]; then
  echo "${common_user_path} already exists"
else
  mkdir -p $(dirname ${common_user_path})
  echo "Generating ${common_user_path}"
  touch ${common_user_path}
  cat << EOF > ${common_user_path}
${prefix}
{
  age.identityPaths = [ "\${config.home.homeDirectory}/.ssh/id_ed25519" ];

  imports = [];

  # Common to your user on all machines.
  home.packages = with pkgs; [];
}
EOF
fi

host_user_default_path="./hosts/${host}/users/${username}/default.nix"
type_file=$( [[ $is_headless == 'y' ]] && echo 'headless' || echo 'desktop')

if [ -f ${host_user_default_path} ]; then
  echo "${host_user_default_path} already exists"
else
  mkdir -p $(dirname ${host_user_default_path})
  echo "Generating ${host_user_default_path}"
  touch ${host_user_default_path}
  cat << EOF > ${host_user_default_path} 
${prefix}
let
  common_dir = ../../../_common;
  xdg = import (common_dir + /home/xdg.nix) { inherit config; };
in
{
  imports = [
    (common_dir + /home/types/${type_file}.nix)
  ];

  home = {
    stateVersion = "21.05";

    # For just this user on this machine.
    packages = with pkgs; [];
  };
}
EOF
fi

host_user_config_path="./hosts/${host}/users/${username}/config.nix"
home_root=$( [[ $is_mac_os == 'y' ]] && echo 'Users' || echo 'home' )

if [ -f ${host_user_config_path} ]; then
  echo "${host_user_config_path} already exists"
else
  mkdir -p $(dirname ${host_user_config_path})
  echo "Generating ${host_user_config_path}"
  touch ${host_user_config_path}
  cat << EOF > ${host_user_config_path}
${prefix}
{
  shell = pkgs.zsh;
  home = "/${home_root}/${username}";
  description = "${username}";
  createHome = true;
  isNormalUser = true;
  extraGroups = [];
}
EOF
fi

echo "${username}@${host} done being generated"
