{ pkgs }:

let
  src = pkgs.fetchFromGitHub {
    owner = "czottmann";
    repo = "pi-automode";
    rev = "4d902a2ce3b2d0887f81194d78616838096afb29";
    sha256 = "1pb74ag9qrs88z9kjrxr7w913d70ad2m81ssd1l9h0lryd4zqn8q";
  };

  # pi-automode's only runtime dependency, itself dependency-free.
  unbash = pkgs.fetchurl {
    url = "https://registry.npmjs.org/unbash/-/unbash-4.0.10.tgz";
    sha256 = "1gmch1hawa2rbqax5h5jdx4r5dvhqqv7izp4528y2b09fp2kvmsg";
  };

  pkg = pkgs.runCommand "pi-automode" { } ''
    cp -r ${src} $out
    chmod -R u+w $out
    mkdir -p $out/node_modules/unbash
    tar -xzf ${unbash} -C $out/node_modules/unbash --strip-components=1
  '';
in
"${pkg}/extensions/auto-mode.ts"
