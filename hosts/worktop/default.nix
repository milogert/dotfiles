{ pkgs, ... }:

rec {
  imports = [
    ../_common/default.nix
    ../_common/tmux.nix
    ../_common/aliases.nix
    ../_common/fonts.nix
    ../_common/zsh.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  environment.systemPackages = with pkgs; [
    #awscli
  ];
}
