{ pkgs, ... }:

{
  environment.etc = {
    "rclone/rclone.conf" = {
      source = "/etc/conf.d/rclone.conf";
      mode = "0644";
    };
  };
}
