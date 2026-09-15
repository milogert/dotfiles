{ config, ... }:

let
  mkPeer =
    {
      name,
      publicKey,
      allowedIPs,
    }:
    {
      inherit name publicKey allowedIPs;
      persistentKeepalive = 25;
    };

  peers = builtins.map mkPeer [
    {
      name = "rbslt";
      publicKey = "m6qGthc6vd/CkuniGT5e3yaWjaZ5ErCDK05MmDZQSWE=";
      allowedIPs = [ "10.100.0.2/32" ];
    }
  ];

in
{
  age.secrets.wireguard-hog-private-key = {
    file = ../../secrets/wireguard/hog-private.age;
    owner = "root";
    group = "root";
    mode = "0400";
  };

  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.100.0.1/24" ];
    listenPort = 51820;
    privateKeyFile = config.age.secrets.wireguard-hog-private-key.path;

    inherit peers;
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];
}
