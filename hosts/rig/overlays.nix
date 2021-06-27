{ pkgs, ... }:

{
  nixpkgs.config = {
    packageOverrides = super: let self = super.pkgs; in {
          #(self: super: {
            tt-rss = super.tt-rss.overrideAttrs (old: rec {
              rev = "cd26dbe64c9b14418f0b2d826a38a35c6bf8a270";
              version = "2021-06-21";
              src = pkgs.fetchurl {
                sha256 = "1dpmzi7hknv5rk2g1iw13r8zcxcwrhkd5hhf292ml0dw3cwki0gm";
                #sha256-9YE4ORu8AVpFEg7C0ibMnHX2UR6Bx/DEzGXbCU/89bY=

                url = "https://git.tt-rss.org/fox/tt-rss/archive/${rev}.tar.gz";
                #https://git.tt-rss.org/fox/tt-rss/archive/cd26dbe64c9b14418f0b2d826a38a35c6bf8a270.tar.gz
              };
            });
            #cd26dbe64c9b14418f0b2d826a38a35c6bf8a270
            #2021-06-21
          };#)
        };
      }
