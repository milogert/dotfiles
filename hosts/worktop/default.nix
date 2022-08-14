{ pkgs, host, ... }:

{
  imports = [
    ../_common/default.nix
    ../_common/types/desktop.nix
    ./darwin/settings.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  # This is nix-darwin specific.
  system.stateVersion = 4;
  users.nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;

    # Disable any sort of prompt that is not Starship.
    promptInit = "";
  };
}
