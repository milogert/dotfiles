{ pkgs, user, ... }:

{
  shell = pkgs.zsh;
  home = "/home/milo";
  description = "Milo Gertjejansen";
  createHome = true;
  isNormalUser = true;
  extraGroups = [
    "wheel"
    "networkmanager"
  ];
}
