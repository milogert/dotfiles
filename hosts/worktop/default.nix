{ pkgs, ... }:

rec {
  imports = [
    ../_common/default.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  #services.activate-system.enable = true;

  # This is required here for nix?.
  #programs.zsh.enable = true;
}
