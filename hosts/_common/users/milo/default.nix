{ config, lib, pkgs, ... }:

let
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
  programs.zsh = {
    shellAliases = moduleAliases;
  };
}
