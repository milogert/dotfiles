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
  fzf-lua-overlay = vimUtils.buildVimPlugin rec {
    name = "fzf-lua-overlay";
    src = fetchFromGitHub {
      owner = "phanen";
      repo = name;
      rev = "ead1f53e3945f1413db0719447ead93e8e089182";
      sha256 = "1pahzr9wj2v5ws2sp91xm6vmjfqsikq2wwnv6fx56s6c0lhf89ij";
    };
  };

  git-permalink-nvim = vimUtils.buildVimPlugin rec {
    name = "git-permalink-nvim";
    src = /Users/milo/git/git-permalink-nvim;
    # src = fetchFromGitHub {
    #   owner = "milogert";
    #   repo = name;
    #   rev = "2d41bacd16370bd4f0e5327e947c70708d6c94df";
    #   sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
    # };
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

  supermaven-nvim = vimUtils.buildVimPlugin rec {
    name = "supermaven-nvim";
    src = fetchFromGitHub {
      owner = "supermaven-inc";
      repo = name;
      rev = "d71257f431e190d9236d7f30da4c2d659389e91f";
      sha256 = "00wmbl3882j2nydy38mgcar73x7im8qyiw7svi0dcdb108yqi4xz";
    };
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

  nvim-nio = vimUtils.buildVimPlugin rec {
    name = "nvim-nio";
    src = fetchFromGitHub {
      owner = "nvim-neotest";
      repo = name;
      rev = "173f285eebb410199273fa178aa517fd2d7edd80";
      sha256 = "0favgnfpsak44lzyzyhfavazr2i64l7ysk370xm4wbrb51kjsdkf";
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

  playtime-nvim = vimUtils.buildVimPlugin rec {
    name = "playtime.nvim";
    src = fetchFromGitHub {
      owner = "rktjmp";
      repo = name;
      rev = "ab7d232c02341bff8479f532feec5730f8c33770";
      sha256 = "0m22lb3nbsr3fs3nx7rxd9acnh9hjr21ayg7b58x5hyhndkfs1w3";
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
in {
  inherit
    nvim-dap-vscode-js
    vscode-js-debug
  ;
  list = [
    fzf-lua-overlay
    git-permalink-nvim
    output-panel-nvim
    lua-json5
    nvim-dap-vscode-js
    nvim-dev-container
    nvim-nio
    nvim-runscript
    supermaven-nvim
    playtime-nvim
    # vim-ai
    vim-arpeggio
    vim-tada
  ];
}
