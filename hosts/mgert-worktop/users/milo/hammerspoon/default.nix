{ config, pkgs, ... }:

{
  home.file.hammerspoon = {
    source = ./init.lua;
    target = ".hammerspoon/init.lua";
  };
}
