{ pkgs, host, ... }:

{
  imports = [
    ../_common/default.nix
    ./darwin/homebrew.nix
    ./networking.nix
    ./services
  ];

  # This is nix-darwin specific.
  system.stateVersion = 5;
  system.primaryUser = "milo";

  programs.zsh = {
    enable = true;

    # Disable any sort of prompt that is not Starship.
    promptInit = "";
  };
}
