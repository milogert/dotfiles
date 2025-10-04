{
  config,
  lib,
  pkgs,
  ...
}:

let
  common_dir = ../../../_common;

  modules = [
    "neovim"
  ];

  # Edge is the bleeding edge. Head is head of master on git.
  moduleAliasFn = module: {
    "${module}-edge" = "nix run \"${config.home.homeDirectory}/.dotfiles/modules/${module}#\"";
    "${module}-head" = "nix run --no-write-lock-file \"github:milogert/dotfiles#${module}\"";
  };

  moduleAliases = builtins.foldl' (l: r: l // r) { } (builtins.map moduleAliasFn modules);
in
{
  imports = [
    (common_dir + /home/default.nix)
    (common_dir + /home/direnv.nix)
  ];

  home.packages = with pkgs; [
    elixir
    nodejs
    stack
    watchman
    gitoxide
  ];

  programs.git.signing = {
    key = "7291258F2B7C086E";
    signByDefault = true;
    signer = "gpg";
  };

  programs.zsh.shellAliases = {
    borax-docker = "dkCpr && dkIpr && dkNpr && dkVpr && dkYpr";
  }
  // moduleAliases;

  # NPM config options in lieu of no easy static config file
  home.activation.setNpmOptions =
    let
      npmSet = "$DRY_RUN_CMD ${pkgs.nodejs}/bin/npm set";
    in
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      ${npmSet} \
        init-author-name="Milo Gertjejansen" \
        init-author-email="milo@milogert.com" \
        init-author-url="https://milogert.com" \
        init-license="MIT" \
        init-version="0.0.1" \
    '';
}
