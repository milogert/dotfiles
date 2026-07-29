{ pkgs, ... }:

{
  services = {
    nextcloud = {
      enable = true;

      hostName = "cloud.milogert.com";
      https = true;

      config = {
        adminpassFile = "/var/lib/nextcloud.password";
        dbtype = "pgsql";
        dbport = 5432;
        dbhost = "/run/postgresql";
        dbpass = "nextcloud";
      };
    };

    postgresql = {
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions = {
            "DATABASE nextcloud" = "ALL PRIVILEGES";
          };
        }
      ];

      ensureDatabases = [
        "nextcloud"
      ];
    };
  };
}
