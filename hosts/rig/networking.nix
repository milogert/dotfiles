{
  networking = {
    #dns = [
    #  "1.1.1.1"
    #  "1.0.0.1"
    #  "8.8.8.8"
    #];
    #computerName = "rig";
    hostName = "rig"; # Define your hostname.
    #localHostName = "rig";
    #knownNetworkServices = [
    #  "USB 10/100/1000 LAN"
    #  "Wi-Fi"
    #  "Bluetooth PAN"
    #  "Thunderbolt Bridge"
    #];
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s4.useDHCP = true;
    enableIPv6 = false;

    # Configure network proxy if necessary
    #proxy.default = "http://user:password@proxy:port/";
    #proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  };
}
