{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in {
  imports = [
    (common_dir + /home/default.nix)
  ];

}
