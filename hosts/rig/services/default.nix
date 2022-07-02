{ pkgs, ... }:

{
  imports = [
    ./calibre-web.nix
    /* ./nextcloud.nix */
    ./nginx.nix
    ./openssh.nix
  ];

  systemd.services.mount-pstore.enable = false;

  services = {
    # This is not needed, but I'll be explicit.
    cfdyndns = {
      enable = true;
      apikeyFile = "/etc/cloudflare.apikey";
      email = "milo@milogert.com";
      records = [
        "bggrss.milogert.com"
        "books.milogert.com"
        "rss.milogert.com"
        "ssh.milogert.com"
        "usenet.milogert.com"
      ];
    };

    tt-rss = {
      enable = true;
      selfUrlPath = "https://rss.milogert.com";
      auth.autoLogin = false;
      virtualHost = null;
      #database = {
      #  password = "tt_rss";
      #};
      plugins = [
        "auth_internal"
      ];
      pluginPackages = with pkgs; [
        tt-rss-plugin-feediron
      ];
    };

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
