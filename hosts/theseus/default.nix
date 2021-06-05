{ pkgs, ... }:

rec {
  imports = [
    ../_common/default.nix
    ./networking.nix
  ];

  services.activate-system.enable = true;

  # This is required here for nix-darwin.
  programs.zsh.enable = true;

  programs.steam.enable = true;
}
