{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default-headless.nix
    ./networking.nix
    ./services.nix
    #./overlays.nix
    #../_common/services.nix
  ];

  # This is required here for nix-darwin.
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "exa -l -g --git --color always --icons -a -s type";
      ls = "exa --color auto --icons -a -s type";
    };
  };

  environment.systemPackages = with pkgs; [
    ranger
  ];
}
