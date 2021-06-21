{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default-headless.nix
    ./networking.nix
    ./services.nix
    #../_common/services.nix
  ];

  programs.sway.enable = true;

  # TODO: This should belong in the rest of the user config.

  # This is required here for nix-darwin.
  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "exa -l -g --git --color always --icons -a -s type";
      ls = "exa --color auto --icons -a -s type";
    };
  };

  programs.steam.enable = true;

  environment.variables = {
    HOSTNAME = "rig";
  };
  environment.systemPackages = with pkgs; [
    ranger
  ];
}
