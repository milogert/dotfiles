{ config
, pkgs
, ...
}:

{
  imports = [
    ./hammerspoon
  ];

  home.stateVersion = "21.05";

  home.packages = with pkgs; [
    # docker
    git-lfs
    mas
    (yarn.override { nodejs = nodejs-14_x; })
  ];
}
