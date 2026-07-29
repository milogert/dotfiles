{ pkgs, ... }:

{
  imports = [
    ./borgbackup.nix
    ./gpg.nix
    ./postgres.nix
    # ./udev.nix
  ];
}
