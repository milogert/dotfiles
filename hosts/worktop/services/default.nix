{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fuse
    macfuse-stubs
    rclone
  ];

  homebrew.casks = [
    "macfuse"
  ];

  environment.etc = {
    "rclone/rclone.conf" = {
      source = "/etc/conf.d/rclone.conf";
      /* mode = "0644"; */
    };
  };

  /* launchd.daemons.rclone-media-dir = { */
  /*   serviceConfig = { */
  /*     Label = "rclone-media-dir"; */

  /*     Program = "${pkgs.rclone}/bin/rclone"; */
  /*     ProgramArguments = [ */
  /*       "${pkgs.rclone}/bin/rclone" */
  /*       "mount" */
  /*       "b2:milogert-media/" */
  /*       "/var/mnt/media" */
  /*       "--config=/etc/rclone/rclone.conf" */
  /*       "--allow-other" */
  /*       "--allow-non-empty" */
  /*       "--log-level=INFO" */
  /*       "--buffer-size=50M" */
  /*       "--drive-acknowledge-abuse=true" */
  /*       "--no-modtime" */
  /*       "--temp-dir=/var/mnt/download-stream-cache/rclone" */
  /*       "--cache-dir=/var/mnt/download-stream-cache/rclone/cache" */
  /*       "--vfs-cache-mode=full" */
  /*       "--vfs-cache-max-size=250G" */
  /*       "--vfs-read-chunk-size=32M" */
  /*       "--vfs-read-chunk-size-limit=256M" */
  /*     ]; */

  /*     RunAtLoad = true; */
  /*     KeepAlive = true; */

  /*     StandardOutPath = "/tmp/rclone.log"; */
  /*     StandardErrorPath = "/tmp/rclone.error.log"; */
  /*     EnvironmentVariables = { */
  /*       PATH = "${pkgs.fuse}/bin:/usr/bin:/bin:/usr/sbin:/sbin"; */
  /*     }; */
  /*   }; */
  /* }; */
}
