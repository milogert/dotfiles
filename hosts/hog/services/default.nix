{ pkgs, ... }:

{
  imports = [
    ./avahi.nix
    ./homelab
    ./koreader-sync.nix
    ./livebook.nix
    ./nginx.nix
    ./obsidian.nix
    ./openssh.nix
    /* ./openvpn.nix */
    ./printing.nix
    ./rclone.nix
    ./hermes-agent
  ];

  #systemd.services.mount-pstore.enable = false;
}
