{ config
, pkgs
, ...
}:

{
  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    mas
  ];
}
