{
  networking = {
    hostName = "hog";
    hostId = "155a353c";

    /* interfaces.eno1.useDHCP = true; */
    # interfaces.wlp6s0.useDHCP = true;
    /* enableIPv6 = false; */

    # Only open 80 and 443. Ultimately 80 should just redirect to 443 though.
    firewall.allowedTCPPorts = [ 22 80 443 ];

    /* networkmanager.enable = true; */
  };
}
