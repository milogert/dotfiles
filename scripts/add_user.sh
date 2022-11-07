#!/usr/bin/env sh

echo "Adding a user..."

read -p "host: " host
read -p "username: " username

echo "Adding ${username} to ${host}"

common_user_path="./hosts/_common/users/${username}.nix"
host_user_path="./hosts/${host}/users/${username}/config.nix"

if [ -f ${common_user_path} ]; then
  echo "${common_user_path} already exists"
else
  mkdir -p $(dirname ${common_user_path})
  echo "Generating ${common_user_path}"
  touch ${common_user_path}
  cat ${common_user_path} << EOF
# Generated on $(date) for ${username} by $(users) on $(hostname)
{ pkgs, ... }:

{
  #...
}
EOF
fi

if [ -f ${host_user_path} ]; then
  echo "${host_user_path} already exists"
else
  mkdir -p $(dirname ${host_user_path})
  echo "Generating ${host_user_path}"
  touch ${host_user_path}
  cat ${host_user_path} << EOF
# Generated on $(date) for ${username}@${host} by $(users) on $(hostname)
{ pkgs, ... }:

{
  #...
}
EOF
fi

echo "${username}@${host} done being generated"
