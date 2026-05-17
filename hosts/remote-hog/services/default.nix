{ pkgs, ... }:

{
  imports = [
    # ./avahi.nix
    ./homelab
    # ./livebook.nix
    ./group-expenses.nix
    ./infinity-card-generator.nix
    ./nginx.nix
    ./koreader-sync.nix
    ./obsidian.nix
    ./openssh.nix
    /* ./openvpn.nix */
    # ./printing.nix
    # ./rclone.nix
  ];

  #systemd.services.mount-pstore.enable = false;
}
