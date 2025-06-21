{ pkgs, host, ... }:

{
  imports = [
    ../_common/default.nix
    ./darwin/settings.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
    ./services
  ];

  # This is nix-darwin specific.
  system.stateVersion = 5;

  programs.zsh = {
    enable = true;

    # Disable any sort of prompt that is not Starship.
    promptInit = "";
  };
}
