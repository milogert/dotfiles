{ pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./homelab
    ./koreader-sync.nix
    ./livebook.nix
    ./nginx.nix
    ./openssh.nix
    /* ./openvpn.nix */
    ./printing.nix
    ./rclone.nix
  ];

  #systemd.services.mount-pstore.enable = false;
}
