{ pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./homelab
    ./nginx.nix
    ./openssh.nix
    ./printing.nix
    ./rclone.nix
  ];

  #systemd.services.mount-pstore.enable = false;
}
