{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default.nix
    ./networking.nix
    ../_common/services.nix
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
    HOSTNAME = "theseus";
  };
  environment.systemPackages = with pkgs; [
    chromium
    clinfo
    firefox
    flatpak
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.nautilus
    gnomeExtensions.appindicator
    gnomeExtensions.system-monitor
    lshw
    protontricks
    ranger
    solaar
    vulkan-tools
    wineWowPackages.stable
    winetricks
  ];
}
