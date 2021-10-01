{ pkgs, ... }:

{
  services.rsnapshot = {
    enable = true;
    enableManualRsnapshot = true;
    extraConfig = ''
    '';
    cronIntervals = {
    };
  };
}
