{ pkgs, ... }:

{
  services.udev = {
    packages = with pkgs; [
      gnome3.gnome-settings-daemon
    ];

    extraRules = ''
      KERNEL="hidraw*", SUBSYSTEM="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
    '';
  };
}


