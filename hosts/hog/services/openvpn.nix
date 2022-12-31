{ pkgs, ... }:

let
  # generate via openvpn --genkey --secret openvpn-laptop.key
  keys = [
    {
      enabled = true;
      name = "worktop";
      keyFile = "/root/openvpn-worktop.key";
    }
    {
      enabled = false;
      name = "oneplus8";
      keyFile = "/root/openvpn-oneplus8.key";
    }
  ];

  domain = "vpn.milogert.com";
  vpn-dev = "tun0";
  port = 1194;

  openvpnConfig = { name, keyFile, enabled }:
    if enabled
    then {
      services.openvpn.servers.worktop.config = ''
        dev ${vpn-dev}
        proto udp
        ifconfig 10.8.0.1 10.8.0.2
        secret ${keyFile}
        port ${toString port}

        cipher AES-256-CBC
        auth-nocache

        comp-lzo
        keepalive 10 60
        ping-timer-rem
        persist-tun
        persist-key
      '';

      environment.etc."openvpn/${name}-client.ovpn" = {
        text = ''
          dev tun
          remote "${domain}"
          ifconfig 10.8.0.2 10.8.0.1
          port ${toString port}
          redirect-gateway def1

          cipher AES-256-CBC
          auth-nocache

          comp-lzo
          keepalive 10 60
          resolv-retry infinite
          nobind
          persist-key
          persist-tun
          secret [inline]

        '';
        mode = "600";
      };

      system.activationScripts."openvpn-addkey-${name}" = ''
        f="/etc/openvpn/${name}-client.ovpn"
        if ! grep -q '<secret>' $f; then
          echo "appending secret key"
          echo "<secret>" >> $f
          cat ${keyFile} >> $f
          echo "</secret>" >> $f
        fi
      '';
    }
  else {};


  reducer = acc: next : (acc // next);
  init = {
    # sudo systemctl start nat
    networking.nat = {
      enable = true;
      /* externalInterface = <your-server-out-if>; */
      externalInterface = "eno1";
      internalInterfaces  = [ vpn-dev ];
    };
    networking.firewall.trustedInterfaces = [ vpn-dev ];
    networking.firewall.allowedUDPPorts = [ port ];
  };
  keysConfig = builtins.map openvpnConfig keys;
in
  builtins.foldl' reducer init keysConfig
