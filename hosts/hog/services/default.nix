{ pkgs, ... }:

rec {
  imports = [
    ./avahi.nix
    ./home-assistant
    ./homelab
    ./nginx.nix
    ./openssh.nix
    ./printing.nix
  ];

  #systemd.services.mount-pstore.enable = false;
}
