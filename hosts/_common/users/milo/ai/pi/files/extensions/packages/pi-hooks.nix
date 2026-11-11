{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "fyeeme";
    repo = "pi-packages";
    rev = "63b21eed715300f94aaf9dc9a65c11f6d3cab8a2";
    sha256 = "1lqhlmjq6gmx5wvfsfic829v8j2csv7r27hlygnhs0355z9qjim7";
  };
in
"${src}/pi-hooks/index.ts"
