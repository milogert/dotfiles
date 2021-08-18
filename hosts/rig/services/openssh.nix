{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
}
