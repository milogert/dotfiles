{
  networking = {
    hostName = "rig";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s4.useDHCP = true;
    enableIPv6 = false;

    # Only open 80 and 443. Ultimately 80 should just redirect to 443 though.
    firewall.allowedTCPPorts = [ 80 443 ];
  };
}
