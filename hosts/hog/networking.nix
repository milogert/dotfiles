{
  networking = {
    hostName = "hog";
    hostId = "155a353c";

    # The global useDHCP flag is deprecated, therefore explicitly set to false
    # here. Per-interface useDHCP will be mandatory in the future, so this
    # generated config replicates the default behaviour.
    useDHCP = false;
    interfaces.eno1.useDHCP = true;
    # interfaces.wlp6s0.useDHCP = true;
    enableIPv6 = false;

    # Only open 80 and 443. Ultimately 80 should just redirect to 443 though.
    firewall.allowedTCPPorts = [ 22 80 443 ];

    networkmanager.enable = true;
  };
}
