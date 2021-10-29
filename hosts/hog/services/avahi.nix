{ pkgs, ... }:

{
  services.avahi = {
    enable = true;

    openFirewall = true;

    publish = {
      enable = true;
      userServices = true;
    };
  };
}
