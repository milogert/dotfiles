{ pkgs, ... }:

{
  services.avahi = {
    enable = false;

    openFirewall = true;

    publish = {
      enable = true;
      userServices = true;
    };
  };
}
