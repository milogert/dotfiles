{ lib, ... }:

{
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    hostName = "remote-hog";

    nameservers = [
      "2a01:4ff:ff00::add:2"
     "2a01:4ff:ff00::add:1"
   ];

    defaultGateway = "";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };

    dhcpcd.enable = false;

    usePredictableInterfaceNames = lib.mkForce false;

    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="100.64.149.42"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="2a01:4f8:1c1b:6dc9::1"; prefixLength=64; }
          { address="fe80::9400:4ff:fe65:32ec"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = ""; prefixLength = 32; } ];
        ipv6.routes = [ { address = "fe80::1"; prefixLength = 128; } ];
      };

    };

    hosts = {
      "2a01:4f8:c010:d56::2" = ["github.com"];
      "2a01:4f8:c010:d56::3" = ["api.github.com"];
      "2a01:4f8:c010:d56::4" = ["codeload.github.com"];
      "2a01:4f8:c010:d56::5" = ["objects.githubusercontent.com"];
      "2a01:4f8:c010:d56::6" = ["ghcr.io"];
      "2a01:4f8:c010:d56::7" = ["pkg.github.com" "npm.pkg.github.com" "maven.pkg.github.com" "nuget.pkg.github.com" "rubygems.pkg.github.com"];
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="96:00:04:65:32:ec", NAME="eth0"

  '';
}
