{ pkgs, ... }: 

let
  userGroupId = 276;
in {
  imports = [
    ./nzbget.nix
    ./nzbhydra2.nix
    ./overseerr.nix
    ./plex.nix
    ./prowlarr.nix
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

  # This can be started as root because of the --allow-other line below. This
  # makes the volume writeable by anybody.
  systemd.services.rclone-media-dir = {
    enable = true;
    description = "Mount media directory via rclone";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStartPre = "/run/current-system/sw/bin/mkdir -p /mnt/media";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount 'b2:milogert-media/' /mnt/media \
          --config=/etc/rclone/rclone.conf \
          --allow-other \
          --allow-non-empty \
          --log-level=INFO \
          --buffer-size=50M \
          --drive-acknowledge-abuse=true \
          --no-modtime \
          --temp-dir=/mnt/download-stream-cache/rclone \
          --cache-dir=/mnt/download-stream-cache/rclone/cache \
          --vfs-cache-mode=full \
          --vfs-cache-max-size=350G \
          --vfs-read-chunk-size=32M \
          --vfs-read-chunk-size-limit=256M \
          --vfs-cache-max-age=72h0m0s
      '';
      ExecStop = "/run/wrappers/bin/fusermount -u /mnt/media";
      Type = "notify";
      Restart = "always";
      RestartSec = "10s";
      Environment = ["PATH=${pkgs.fuse}/bin:$PATH"];
    };
  };
}
