{ pkgs, homeDirectory }:

import ./ccmux-path-agent-settled.nix {
  inherit pkgs homeDirectory;
  version = "1.4.6";
  source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/epilande/ccmux/d89acbb10403c5ec944ceee701e9c5aa6b358721/src/plugins/pi/ccmux.js";
    hash = "sha256-QRaPKlIYBiWqmjJDH05wPisZHUuXKzaWxt6dfb/EuAA=";
  };
}
