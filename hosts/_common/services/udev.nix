{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [
    gnome3.gnome-settings-daemon
  ];
}


