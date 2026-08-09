{
  stdenv,
  lib,
  fetchFromGitHub,
  pkgs,
}:

let
  rtpPath = "share/tmux-plugins";

  addRtp =
    path: rtpFilePath: attrs: derivation:
    derivation
    // {
      rtp = "${derivation}/${path}/${rtpFilePath}";
    }
    // {
      overrideAttrs = f: mkTmuxPlugin (attrs // f attrs);
    };

  mkTmuxPlugin =
    a@{
      pluginName,
      rtpFilePath ? (builtins.replaceStrings [ "-" ] [ "_" ] pluginName) + ".tmux",
      namePrefix ? "tmuxplugin-",
      src,
      unpackPhase ? "",
      configurePhase ? ":",
      buildPhase ? ":",
      addonInfo ? null,
      preInstall ? "",
      postInstall ? "",
      path ? lib.getName pluginName,
      ...
    }:
    if lib.hasAttr "dependencies" a then
      throw "dependencies attribute is obselete. see NixOS/nixpkgs#118034" # added 2021-04-01
    else
      addRtp "${rtpPath}/${path}" rtpFilePath a (
        stdenv.mkDerivation (
          a
          // {
            pname = namePrefix + pluginName;

            inherit
              pluginName
              unpackPhase
              configurePhase
              buildPhase
              addonInfo
              preInstall
              postInstall
              ;

            installPhase = ''
              runHook preInstall
              target=$out/${rtpPath}/${path}
              mkdir -p $out/${rtpPath}
              cp -r . $target
              if [ -n "$addonInfo" ]; then
                echo "$addonInfo" > $target/addon-info.json
              fi
              runHook postInstall
            '';
          }
        )
      );

  tmuxPaletteSrc = pkgs.fetchFromGitHub {
    owner = "eduwass";
    repo = "tmux-palette";
    rev = "6c254f5280570034e24630960777a4782c56be0e";
    sha256 = "0l2qs9cc784n2c12xc9954qdhd8m1zwlp9dq0kjm98hd6c00icqy";
  };

  tmuxPaletteNodeModules = stdenv.mkDerivation {
    pname = "tmux-palette-node-modules";
    version = "6c254f5";
    src = tmuxPaletteSrc;

    nativeBuildInputs = [ pkgs.bun ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --no-progress --frozen-lockfile
    '';

    installPhase = ''
      mkdir -p $out
      cp -R ./node_modules $out
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-oeyWpohMx/+biiHps/L0JFB2enO4hnR4J54NTgAdN+M=";
  };
in
{
  tmux-palette = mkTmuxPlugin {
    pluginName = "tmux-palette";
    rtpFilePath = "tmux-palette.tmux";
    version = "6c254f5";
    src = tmuxPaletteSrc;
    nativeBuildInputs = [ pkgs.bun ];
    postInstall = ''
      cp -R ${tmuxPaletteNodeModules}/node_modules $out/${rtpPath}/tmux-palette/
      substituteInPlace $out/${rtpPath}/tmux-palette/bin/tmux-palette.sh \
        --replace-fail 'exec bun ' 'exec ${pkgs.bun}/bin/bun ' \
        --replace-fail 'MEASURE="$(bun ' 'MEASURE="$(${pkgs.bun}/bin/bun '
      substituteInPlace $out/${rtpPath}/tmux-palette/tmux-palette.tmux \
        --replace-fail 'command -v bun' 'command -v ${pkgs.bun}/bin/bun' \
        --replace-fail 'bun install' '${pkgs.bun}/bin/bun install'
    '';
  };

  srcery-tmux = mkTmuxPlugin {
    pluginName = "srcery";
    version = "now";
    src = pkgs.fetchFromGitHub {
      owner = "srcery-colors";
      repo = "srcery-tmux";
      rev = "531b4f9a260826b0a99ebd038a0d275ad0275e64";
      sha256 = "0h9wx6rkccn13n593z4vcq4jwg3m3vjfwllr85xg7gr93yh83sfn";
    };
  };
}
