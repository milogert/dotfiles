{ pkgs, ... }:

rec {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default.nix
    ./networking.nix
    ../_common/services.nix
  ];

  # This goes here since it's different between nixos and darwin.
  fonts.fontDir.enable = true;

  programs.sway.enable = true;

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "exa -l -g --git --color always --icons -a -s type";
      ls = "exa --color auto --icons -a -s type";
    };
  };

  programs.steam.enable = true;

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
