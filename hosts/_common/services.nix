{ pkgs, ... }: 

{
  # For yubikey smart card use with gpg.
  services = {
    pcscd.enable = true;

    udev.packages = with pkgs; [
      gnome3.gnome-settings-daemon
      solaar
    ];
  };
}
