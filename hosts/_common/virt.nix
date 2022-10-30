{ pkgs, ... }:

{
  virutalisation.qemu = {
    drives = [
      {
        name = "default";
        name = /var/lib/qemu/disks/default.img;
      }
    ];
  };
}
