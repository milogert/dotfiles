{ pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default.nix
    ../_common/types/headless.nix
    ./networking.nix
    ./wireguard.nix
    ./services
    ../_common/services
  ];

  # This is required here for nix-darwin.
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "eza -l -g --git --color always --icons -a -s type";
      ls = "eza --color auto --icons -a -s type";
    };
  };

  environment.systemPackages = with pkgs; [
    ranger
    rclone
  ];
}
