{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default.nix
    ./networking.nix
    ./services.nix
    #./sway.nix
  ];

  programs.sway.enable = true;

  # TODO: This should belong in the rest of the user config.

  # This is required here for nix-darwin.
  programs.zsh.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    chromium
  ];
}
