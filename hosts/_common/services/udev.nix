{ pkgs, ... }:

{
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];
}
