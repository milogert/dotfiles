{ pkgs, ... }:

{
  # For yubikey smart card use with gpg.
  services.pcscd.enable = true;
}
