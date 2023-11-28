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

  programs.sway.enable = true;

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "eza -l -g --git --color always --icons -a -s type";
      ls = "eza --color auto --icons -a -s type";
    };

    promptInit = "";
  };

  programs.steam.enable = true;

  virtualisation.lxd.enable = true;

  #security.pam = {
  #  u2f.enable = true;
  #  services.gdm-password.text = ''
  #    auth      required      pam_u2f.so
  #    auth      substack      login
  #    account   include       login
  #    password  substack      login
  #    session   include       login
  #  '';
  #};

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
