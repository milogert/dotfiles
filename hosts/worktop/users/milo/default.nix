{ config
, pkgs
, ...
}:

let
  home_dir = "${config.home.homeDirectory}";
  common_dir = ../../../_common;
in rec {
  imports = [
    (common_dir + "/home/git")
    (common_dir + "/home/neovim")
    (common_dir + "default.nix")
  ];

  xdg = {
    enable = true;
    cacheHome = "${home_dir}/.cache";
    configHome = "${home_dir}/.config";
    dataHome = "${home_dir}/.data";
  };

  home.stateVersion = "21.05";

  home.file = {
    ".mac_specific".source = common_dir + "/config/mac_specific";
  } // home.file;

  programs.git.signing.key = "696FAC60B36CA0D3";

  home.packages = with pkgs; [
    #bashcards
    elixir
    git-lfs
    #haskellPackages.pandoc
    #haskellPackages.patat
    nodejs-14_x
    ruby
    (yarn.override { nodejs = nodejs-14_x; })
  ];

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs-16_x}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} init.author.name "Milo Gertjejanse"
        ${npmSet} init.author.email "milo@milogert.com"
        ${npmSet} init.author.url "https://milogert.com"
        ${npmSet} init.license "MIT"
        ${npmSet} init.version "0.0.1"
      '';

#  home.activation.setSSH =
#    config.lib.dag.entryAfter ["writeBoundary"] ''
#      if [[ ! -f "$HOME/.ssh/id_rsa" ]]; then
#        echo "ssh: Setting up key..."
#        ssh-keygen -t rsa -b 4096 -C "me@robertwpearce.com"
#
#        echo "ssh: Starting ssh-agent in the background"
#        eval "$(ssh-agent -s)"
#
#        echo "ssh: writing config to store passphrases in keychain"
#        cat <<EOF > "$HOME/.ssh/config"
#Host *
#  AddKeysToAgent yes
#  UseKeychain yes
#  IdentityFile "$HOME/.ssh/id_rsa"
#EOF
#
#        echo "ssh: Adding private key to ssh-agent and storing passphrase in keychain"
#        ssh-add -K "$HOME/.ssh/id_rsa"
#      fi
#    '';

  home.activation.setVimDirs =
    config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p ${xdg.dataHome}/nvim/backup/
      mkdir -p ${xdg.dataHome}/nvim/swap/
      mkdir -p ${xdg.dataHome}/nvim/undo/
    '';
}
