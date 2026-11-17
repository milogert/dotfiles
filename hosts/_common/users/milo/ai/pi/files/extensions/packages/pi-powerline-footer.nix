{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "nicobailon";
    repo = "pi-powerline-footer";
    # Upstream #248 fixes custom-message runs (including PR feedback).
    rev = "2260ae6fee41ae2cb3d0d3d6609d5231fe57d004";
    sha256 = "169178l2ch4yhms1hiyn8h7cihshsqjlv5izhljh76y0rdcr1xdw";
  };
  patched = import ./pi-powerline-footer-path-overflow-above.nix { inherit pkgs src; };
in
"${patched}/index.ts"
