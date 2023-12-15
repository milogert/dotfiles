{ buildNpmPackage
, darwin
, fetchFromGitHub
, lib
, nodejs
, python3
, stdenv
, vimUtils
, fetchgit
, cargo
, rustPlatform
, cacert
}:

let
  art-nvim = vimUtils.buildVimPlugin {
    name = "art-nvim";
    src = builtins.fetchGit {
      url = "git@github.com:articulate/art-nvim.git";
      rev = "33b19e043cefb7a7db9bc9378efda2a6eaa9fd83";
    };
  };

  git-permalink-nvim = vimUtils.buildVimPlugin rec {
    name = "git-permalink-nvim";
    src = fetchFromGitHub {
      owner = "milogert";
      repo = name;
      rev = "2d41bacd16370bd4f0e5327e947c70708d6c94df";
      sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
    };
  };

  hardtime-nvim = vimUtils.buildVimPlugin rec {
    name = "hardtime.nvim";
    src = fetchFromGitHub {
      owner = "m4xshen";
      repo = name;
      rev = "8cc4dec29a177cb7c33a900ccf45b451684c30a0";
      sha256 = "0q8hpvy61qc5pbxbzkf5zna71j7h8xbvqjs23x8bimkhwgk21j0k";
    };
  };

  lua-json5-bin = rustPlatform.buildRustPackage rec {
    pname = "lua-json5";
    version = "014fcab8093b48b3932dd0d51ae2d98bbb578d67";
    src = fetchFromGitHub {
      owner = "Joakker";
      repo = pname;
      rev = version;
      sha256 = "0dhzqrp0jv7nk3m29qibz581bhin738pkg3gn8ahk5dz7dkwzlkj";
    };

    cargoHash = "sha256-+zXYDYVbXaapu1cdVGmRDgi6r2Ns09PzOFPdTgRHxOI=";
    RUSTFLAGS = "-C link-arg=-undefined -C link-arg=dynamic_lookup";
  };

  lua-json5 = vimUtils.buildVimPlugin rec {
    name = "lua-json5";
    src = fetchFromGitHub {
      owner = "Joakker";
      repo = name;
      rev = "014fcab8093b48b3932dd0d51ae2d98bbb578d67";
      sha256 = "0dhzqrp0jv7nk3m29qibz581bhin738pkg3gn8ahk5dz7dkwzlkj";
    };

    postInstall = ''
      cp ${lua-json5-bin}/lib/liblua_json5.dylib $out/lua/json5.dylib
    '';
  };

  nvim-dap-vscode-js = vimUtils.buildVimPlugin rec {
    name = "nvim-dap-vscode-js";
    src = fetchFromGitHub {
      owner = "mxsdev";
      repo = name;
      rev = "03bd29672d7fab5e515fc8469b7d07cc5994bbf6";
      sha256 = "1nj299by3qs0dbsv1lxb19ia9pbpspw22kdlrilwl8vqixl77ngi";
    };
  };

  vscode-js-debug = stdenv.mkDerivation rec {
    pname = "vscode-js-debug";
    version = "v1.85.0";
    src = fetchFromGitHub {
      owner = "microsoft";
      repo = pname;
      rev = version;
      hash = "sha256-mBXH3tqoiu3HIo1oZdQCD7Mq8Tvkt2DXfcoXb7KEgXE=";
    };

    nativeBuildInputs = [
      python3
      nodejs
      cacert
    ] ++ lib.optionals stdenv.isDarwin [
      darwin.cctools
    ];
    makeCacheWritable = true;
    dontNpmBuild = true;

    configurePhase = ''
      runHook preConfigure

      export HOME=$(pwd)
      npm install --legacy-peer-deps

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      export HOME=$(pwd)
      npx gulp vsDebugServerBundle
      mkdir -p $out/out
      cp -r dist/* $out/out

      runHook postBuild
    '';

  };

  nvim-dev-container = vimUtils.buildVimPlugin rec {
    name = "nvim-dev-container";
    src = fetchgit {
      url = "https://codeberg.org/esensar/${name}";
      rev = "bc3f5c02fe04078a3388a9087ef6c996a2928947";
      sha256 = "1zn6pis90p8qp9sa8bqihrspzy807xm5wr2c700kpz4czl74wsy2";
    };
  };

  nvim-runscript = vimUtils.buildVimPlugin rec {
    name = "nvim-runscript";
    src = fetchFromGitHub {
      owner = "klesh";
      repo = name;
      rev = "fd0b3d008a32499f73d0a160612b39f33325f85f";
      sha256 = "1mys3rzg3wxjmxrg13p6hvw7gwk8wi3mi8h7haswy0239kkpaz27";
    };
  };

  vim-ai = vimUtils.buildVimPlugin rec {
    name = "vim-ai";
    src = fetchFromGitHub {
      owner = "madox2";
      repo = name;
      rev = "6ae66e51f29c60537b7e931f85cc6f452b6cc651";
      sha256 = "1q9xvl99r1ar6j7bwq9hwdm5rsp239dgha8ljl15dwqfldr3p4w8";
    };
  };

  vim-arpeggio = vimUtils.buildVimPlugin rec {
    name = "vim-arpeggio";
    src = fetchFromGitHub {
      owner = "kana";
      repo = name;
      rev = "01c8fc1a72ef58e490ee0490c65ee313b1b6e843";
      sha256 = "0405yp1273kzsr3g5j6mj2dfs73qvw716474phkdr67md8ln12dy";
    };
  };

  vim-tada = vimUtils.buildVimPlugin rec {
    name = "vim-tada";
    src = fetchFromGitHub {
      owner = "dewyze";
      repo = name;
      rev = "625ad428a818041cbbc63e055049108ef5b436a1";
      sha256 = "1rdfw25lljv53h2f2nc1gmx9awggk7k3nrfj46ssl11jn6lyvbj8";
    };
  };

  output-panel-nvim = vimUtils.buildVimPlugin rec {
    name = "output-panel.nvim";
    src = fetchFromGitHub {
      owner = "mhanberg";
      repo = name;
      rev = "65bb44a5d5dbd40f3793a8c591b65a0c5f260bd9";
      sha256 = "0wpjf25mqlafs0psi5kn3nxn4xnadfpfh9frf0zz8x72qfxkfv8s";
    };
  };
in {
  inherit
    nvim-dap-vscode-js
    vscode-js-debug
  ;
  list = [
    art-nvim
    git-permalink-nvim
    hardtime-nvim
    lua-json5
    nvim-dap-vscode-js
    nvim-dev-container
    nvim-runscript
    vim-ai
    vim-arpeggio
    vim-tada
    output-panel-nvim
  ];
}
