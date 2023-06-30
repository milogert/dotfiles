{
  networking = {
    hostName = "veem";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    #interfaces.wlp6s0.useDHCP = true;
    #interfaces.enp9s0.useDHCP = true;
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
  };
}
