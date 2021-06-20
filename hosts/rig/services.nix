{ pkgs, ... }:

{
  services = {
    longview = {
      enable = false;
      apiKey = "";

      apacheStatusUrl = "";
      nginxStatusUrl = "";

      mysqlUser = "";
      mysqlPassword = "";
    };
  };
}
