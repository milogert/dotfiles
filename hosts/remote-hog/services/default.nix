{ pkgs, ... }:

{
  imports = [
    # ./avahi.nix
    ./homelab
    # ./livebook.nix
    ./nginx.nix
    ./openssh.nix
    /* ./openvpn.nix */
    # ./printing.nix
    # ./rclone.nix
  ];

  #systemd.services.mount-pstore.enable = false;
}
