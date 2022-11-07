{ pkgs, ... }:

let
  mountBase = "/private/var/mnt";
in {
  environment.systemPackages = with pkgs; [
    fuse
    macfuse-stubs
    rclone
    rsync
  ];

  homebrew.casks = [
    "macfuse"
  ];

  environment.etc."rclone/rclone.conf".source = "/etc/conf.d/rclone.conf";

  /* services.cron.systemCronJobs = [ */
  /*   "1 0 * * * ${pkgs.rsync}/bin/rsync -a -P ${mountBase}/calibre ${mountBase}/media/Books" */
  /* ]; */

  launchd.daemons.rclone-media-dir = {
    serviceConfig = {
      Label = "rclone-media-dir";

      Program = "${pkgs.rclone}/bin/rclone";
      ProgramArguments = [
        "${pkgs.rclone}/bin/rclone"
        "cmount"
        "b2:milogert-media/"
        "${mountBase}/media"
        "--config=/etc/conf.d/rclone.conf"
        "--allow-other"
        "--log-level=INFO"
        "--buffer-size=50M"
        "--drive-acknowledge-abuse=true"
        "--no-modtime"
        "--temp-dir=${mountBase}/download-stream-cache/rclone"
        "--cache-dir=${mountBase}/download-stream-cache/rclone/cache"
        "--vfs-cache-mode=full"
        "--vfs-cache-max-size=250G"
        "--vfs-read-chunk-size=32M"
        "--vfs-read-chunk-size-limit=256M"
      ];

      RunAtLoad = true;
      KeepAlive = true;

      StandardOutPath = "/tmp/rclone.log";
      StandardErrorPath = "/tmp/rclone.error.log";
      EnvironmentVariables = {
        PATH = "${pkgs.fuse}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
