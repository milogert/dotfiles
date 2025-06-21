{ pkgs, user, name, otherOptions, ... }:

{
  shell = pkgs.zsh;
  home = "/home/${user}";
  description = name;
  createHome = true;
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];
} // otherOptions
