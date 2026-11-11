{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "hsingjui";
    repo = "pi-statusline";
    rev = "894a3d883b87753fa5018dff68f85a2d6a1dfe1c";
    sha256 = "0z13r9iz302jh1wd6jiabrh3jjhqldw1j5cvhyd1r650zinq56iz";
  };
in "${src}/src/index.ts"
