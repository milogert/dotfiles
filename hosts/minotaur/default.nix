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
  system.stateVersion = 4;
  nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;

    # Disable any sort of prompt that is not Starship.
    promptInit = "";
  };

  ids.uids.nixbld = 400;
}
