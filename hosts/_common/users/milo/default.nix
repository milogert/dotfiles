{ config, lib, pkgs, ... }:

let
  common_dir = ../../../_common;

  modules = [
    "neovim"
  ];

  moduleAliasFn = module: {
    "run-${module}" =
      "nix run \"${config.home.homeDirectory}/.dotfiles/modules/${module}#\"";
    "github-${module}" =
      "nix run --no-write-lock-file \"github:milogert/dotfiles#${module}\"";
  };

  moduleAliases = builtins.foldl' (l: r: l // r)  {} (builtins.map moduleAliasFn modules);
in {
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/direnv.nix)
  ];

  home.packages = with pkgs; [
    asdf-vm
    elixir
    nodejs
    watchman
  ];

  programs.git.signing = {
    key = "7291258F2B7C086E";
    signByDefault = true;
    gpgPath = "gpg";
  };

  programs.zsh.shellAliases = {} // moduleAliases;

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs-16_x}/bin/npm set";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        ${npmSet} \
          init-author-name="Milo Gertjejansen" \
          init-author-email="milo@milogert.com" \
          init-author-url="https://milogert.com" \
          init-license="MIT" \
          init-version="0.0.1" \
      '';
}
