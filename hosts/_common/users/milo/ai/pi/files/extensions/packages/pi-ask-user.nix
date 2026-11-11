{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "capdiem";
    repo = "pi-extensions";
    rev = "67a9cd50316b63593bd27212c9368805d84b6206";
    sha256 = "0h4msibx1gr0k4gxsrxyl9f91dh21bk9d6169a4sf27z6705xksb";
  };
in
"${src}/extensions/pi-ask-user/index.ts"
