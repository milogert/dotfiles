{ pkgs, ... }: 

let
  userGroupId = 276;
in {
  imports = [
    ./nzbget.nix
    ./nzbhydra2.nix
    ./plex.nix
    ./radarr.nix
    ./readarr.nix
    ./sonarr.nix

    # Future
    # ./overseerr.nix # https://overseerr.dev/
    # ./tdarr.nix # https://tdarr.io/
  ];

  users.users.media = {
    home = "/var/lib/media";
    createHome = true;
    group = "media";
    extraGroups = [ "media" ];
    uid = userGroupId;
    isSystemUser = true;
    shell = pkgs.zsh;
  };

  users.groups.media = {
    members = [ "media" ];
    gid = userGroupId;
  };
}
