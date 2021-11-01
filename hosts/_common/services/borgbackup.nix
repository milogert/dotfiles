{ pkgs, ... }:

{
  services.borgbackup = {
    jobs = {
      mediaJob = {
        repo = "/var/lib/borgbackup/mediaRepo";
        encryption.mode = "none";
        paths = [
          "/var/lib/radarr/.config"
          "/var/lib/sonarr/.config"
          "/var/lib/plex/Plex Media Server"
          "/var/lib/heimdall/www/app.sqlite"
        ];

      };
    };

    repos = {
      mediaRepo = {
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZSp5UznCf8ayy6aYrvGJJz+3LG3REXUQS8kZJG8CkdVcqJJQ/ql1DAyDP6/GcHWcWNY7703NGbsxDyIAnnTknV471YkvQbIfmZr8gsQDZV1P6NXuaddYamz0sVem/gmOsg0PsC5uRSVu5qHVP4F7q6MWI4yGgm4dHoc+BHARJyqdepm5QhlZcEoZknPJQhmjwQlGK1OW1FzclYbFlliv0JN4+9W7I2us8VKy7fc0M7J7O+CgA/+ZIv70oJRuFrU+M7jJu1wylySjPMXGfk9uKexduqX/OLdIfEl3BSdNwlN6LGOKX+ou/xvxI+YB/IP3NeHAFDwvg0s/7qG+/CAHMV/uJr9RJYD9TzHkeCFeCIwKai70qCDbCd1cMJ/5OjPrFie9SZABAJ4r8Fx2tGfCw4jDggiyYlOOvQJSBkqGUIQrUfZx5nmGKmbKT/ZytF6TWbBnKowqNhCdv6KFBZmkMcvjDzFD4v8v+NRRCxDW5lYCDOItr91DeL6bq9ljpc1M= milo@theseus"
        ];
      };
    };
  };
}
