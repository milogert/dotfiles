{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "DietrichGebert";
    repo = "ponytail";
    rev = "e3ba2aa6f1e6f0bc4d69eb09c9f0d0a93af56156";
    sha256 = "01386kw1kg1wpgjmyzc9154b8v4hf8s10iv5bm0lbiwqnigbji1w";
  };
in
"${src}/pi-extension/index.js"
