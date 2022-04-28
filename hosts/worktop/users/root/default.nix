{ config
, pkgs
, ...
}:

let
  common_dir = ../../../_common;
in rec {
  imports = [
    (common_dir + /home/default.nix)
  ];

}
