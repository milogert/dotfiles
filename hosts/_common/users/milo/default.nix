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

  programs.zsh = {
    shellAliases = {
    } // moduleAliases;
  };

  home.packages = with pkgs; [
    asdf-vm
    nodejs
    elixir
  ];
}
