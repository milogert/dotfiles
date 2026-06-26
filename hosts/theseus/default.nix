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

  programs = {
    zsh = {
      enable = true;

      shellAliases = {
        ll = "eza -l -g --git --color always --icons -a -s type";
        ls = "eza --color auto --icons -a -s type";
      };

      promptInit = "";
    };

    steam.enable = true;
    steam.remotePlay.openFirewall = true;
  };

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

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    clinfo
    gjs
    kmail
    lshw
    protontricks
    solaar
    vulkan-tools
    wineWowPackages.stable
    winetricks
  ];
}
