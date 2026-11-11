{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-powerline-footer";
    rev = "5df60404caa1b9b8706ee75c7ce7d9552bb1fd2c";
    sha256 = "18navhl9q5jsrx7maqwn9klp7ags31ad4192i76295hswlan81hx";
  };
  patched = import ./pi-powerline-footer-path-overflow-above.nix { inherit pkgs src; };
in
"${patched}/index.ts"
