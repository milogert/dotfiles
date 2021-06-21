{ pkgs, ... }:

rec {
  imports = [
    ../_common/default.nix
    ./darwin/settings.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  system.stateVersion = 4;
  users.nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;
  #services.activate-system.enable = true;

  # This is required here for nix?.
  programs.zsh.enable = true;
}
