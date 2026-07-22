{
  ...
}:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;
    settings = {
      "*" = {
        IdentityAgent = [ "SSH_AUTH_SOCK" ];

        # Formerly the default configuration, keeping this around for the heck of it.
        ForwardAgent = false;
        AddKeysToAgent = "no";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "~/.ssh/known_hosts";
        ControlMaster = "no";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "no";
      };

      "hog theseus remote-hog home.milogert.com" = {
        RemoteForward = {
          bind.address = "/run/user/1000/gnupg/S.gpg-agent";
          host.address = "/Users/milo/.gnupg/S.gpg-agent.extra";
        };
      };
    };
  };
}
