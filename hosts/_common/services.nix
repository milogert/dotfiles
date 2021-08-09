{ pkgs, ... }: 

{
  # For yubikey smart card use with gpg.
  services = {
    pcscd.enable = true;

    udev.packages = with pkgs; [
      gnome3.gnome-settings-daemon
      solaar
    ];

    pgmanage = {
      enable = false;
      allowCustomConnections = true;

      connections = {
        localhost = "hostaddr=127.0.0.1 port=5432 dbname=postgres";
      };
    };

    postgresql = {
      enable = true;

      authentication = ''
        # allow postgres user to use "ident" authentication on Unix sockets
        # (as per recent comments, omit "sameuser" if on postgres 8.4 or later)
        #local   all   postgres                         ident sameuser
        # allow all other users to use "md5" authentication on Unix sockets
        #local   all   all                              md5
        local   all   all                              trust
        # for users connected via local IPv4 or IPv6 connections, always require md5
        host    all   all        127.0.0.1/32          md5
        host    all   all        ::1/128               md5
      '';
    };
  };
}
