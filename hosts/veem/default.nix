{ pkgs, ... }:

{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../_common/default.nix
    ./networking.nix
    ../_common/services
    ./services
  ];

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "eza -l -g --git --color always --icons -a -s type";
      ls = "exa --color auto --icons -a -s type";
    };

    promptInit = "";
  };

  virtualisation.lxd.enable = true;

  environment.systemPackages = with pkgs; [
    beekeeper-studio
    clinfo
    firefox
    gjs
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnome.gnome-keyring
    gnome.gnome-system-monitor
    gnome.nautilus
    gnome.seahorse
    gnomeExtensions.appindicator
    gnomeExtensions.espresso
    gnomeExtensions.screenshot-tool
    gnomeExtensions.vitals
    lshw
    protontricks
    ranger
    solaar
    vulkan-tools
    wineWowPackages.stable
    winetricks
  ];
}
