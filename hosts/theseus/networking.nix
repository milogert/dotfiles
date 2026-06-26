{
  networking = {
    hostName = "theseus";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp7s0.useDHCP = true;
    # interfaces.enp9s0.useDHCP = true;
    enableIPv6 = true;

    # Use NetworkManager, if there is slow DNS resolution try uncommenting the
    # items below.
    networkmanager = {
      enable = true;

      # insertNameservers = [
      #   "1.1.1.1"
      #   "1.0.0.1"
      #   "8.8.8.8"
      # ];

      # dns = "none";
    };

    firewall.allowedTCPPorts = [
      42000 # Warpinator
      42001 # Warpinator
      27015 27036 # Space Marine 2
    ];

    firewall.allowedUDPPorts = [
      27015 # Space Marine 2
    ];

    firewall.allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    firewall.allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
      { from = 27031; to = 27036; } # Space Marine 2
    ];
  };
}
