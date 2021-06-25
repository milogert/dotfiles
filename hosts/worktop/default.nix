{ pkgs, host, ... }:

rec {
  imports = [
    ../_common/default.nix
    ./darwin/settings.nix
    ./darwin/homebrew.nix
    ./darwin/nix-apps.nix
    ./networking.nix
  ];

  #environment.variables.HOSTNAME = "worktop";
  # This goes here since it's different between nixos and darwin.
  fonts.enableFontDir = true;

  # This is nix-darwin specific.
  system.stateVersion = 4;
  users.nix.configureBuildUsers = true;
  services.nix-daemon.enable = true;

  programs.zsh = {
    enable = true;

    #shellInit = ''
    #  alias ll="exa -l -g --git --color always --icons -a -s type";
    #  alias ls="exa --color auto --icons -a -s type";
    #'';

    promptInit = "";
  };
}
