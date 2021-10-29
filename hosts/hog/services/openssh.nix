{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    openFirewall = true;
    passwordAuthentication = false;
  };
}
