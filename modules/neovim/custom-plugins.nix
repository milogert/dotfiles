{ fetchFromGitHub
, vimUtils
, rustPlatform
}:

let
  blink-cmp-supermaven = vimUtils.buildVimPlugin rec {
    name = "blink-cmp-supermaven";
    src = fetchFromGitHub {
      owner = "Huijiro";
      repo = name;
      rev = "635ce12e9e2d2a5a483728ac764d0bc5b57af23b";
      sha256 = "0f0nvriv6hh986j0br8xvfpm7l5267pfsj6gmx01g4fsxkrbjnx5";
    };
    doCheck = false;
  };

  conform-nvim = vimUtils.buildVimPlugin rec {
    name = "conform.nvim";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = name;
      rev = "f8929b32acb8712381621b42ef3b0219c3c41efd";
      sha256 = "0m29mrgz1289hjzh3s8068hv5d0ks7rd6mjl715iv1d048d1sp78";
    };
    doCheck = false;
  };

  git-permalink-nvim = vimUtils.buildVimPlugin rec {
    name = "git-permalink-nvim";

    # src = /Users/milo/git/git-permalink-nvim;
    src = fetchFromGitHub {
      owner = "milogert";
      repo = name;
      rev = "2d41bacd16370bd4f0e5327e947c70708d6c94df";
      sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
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
    doCheck = false;
  };

  js-i18n-nvim = vimUtils.buildVimPlugin rec {
    name = "js-i18n.nvim";
    src = fetchFromGitHub {
      owner = "nabekou29";
      repo = name;
      rev =  "c1ffe818b08d1f5b1f53c26e7bd9fd9efaafef9e";
      sha256 = "sha256-qEYZbnzPrft9lVFtzAjYnVTlc1H95bTlaNLBZmFn2e0=";
    };
    doCheck = false;
  };

  lua-json5-bin = rustPlatform.buildRustPackage rec {
    useFetchCargoVendor = true;
    pname = "lua-json5";
    version = "014fcab8093b48b3932dd0d51ae2d98bbb578d67";
    src = fetchFromGitHub {
      owner = "Joakker";
      repo = pname;
      rev = version;
      sha256 = "0dhzqrp0jv7nk3m29qibz581bhin738pkg3gn8ahk5dz7dkwzlkj";
    };

    cargoHash = "sha256-lMBA8OidN1GGHmIGvJhkLudeEe+RODk1+xdDT2ElEhw=";
    # RUSTFLAGS = "-C link-arg=-undefined -C link-arg=dynamic_lookup";
  };

  lua-json5 = vimUtils.buildVimPlugin rec {
    name = "lua-json5";
    src = fetchFromGitHub {
      owner = "Joakker";
      repo = name;
      rev = "014fcab8093b48b3932dd0d51ae2d98bbb578d67";
      sha256 = "sha256-ctLPZzu/lQkVsm+8edE4NsIVUPkr4iTqmPZsCW7GHzY=";
    };

    # postInstall = ''
    #   cp ${lua-json5-bin}/lib/liblua_json5.dylib $out/lua/json5.dylib
    # '';
    postInstall = ''
      strip ${lua-json5-bin}/lib/liblua_json5.so -o $out/lua/json5.so
    '';
    doCheck = false;
  };

  none-ls-extras-nvim = vimUtils.buildVimPlugin rec {
    name = "none-ls-extras.nvim";
    src = fetchFromGitHub {
      owner = "nvimtools";
      repo = name;
      rev = "6557f20e631d2e9b2a9fd27a5c045d701a3a292c";
      sha256 = "sha256-cd7HJLfLbVs7v+eE+8JrDc0nj/DOGVTbwNEMdZsf2qk=";
    };
    doCheck = false;
  };

  nvim-dap-vscode-js = vimUtils.buildVimPlugin rec {
    name = "nvim-dap-vscode-js";
    src = fetchFromGitHub {
      owner = "mxsdev";
      repo = name;
      rev = "03bd29672d7fab5e515fc8469b7d07cc5994bbf6";
      sha256 = "1nj299by3qs0dbsv1lxb19ia9pbpspw22kdlrilwl8vqixl77ngi";
    };
    doCheck = false;
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

  bloat-nvim = vimUtils.buildVimPlugin rec {
    name = "bloat.nvim";
    src = fetchFromGitHub {
      owner = "dundalek";
      repo = name;
      rev = "f90bef655ac40fecbaae53e10db1cf7894d090b1";
      sha256 = "0ah5c84172wkc75zx5ll2dp9y3r867lik29aw5mm7i3lj530p0ri";
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
  ;
  list = [
    blink-cmp-supermaven
    bloat-nvim
    conform-nvim
    git-permalink-nvim
    js-i18n-nvim
    lua-json5
    nvim-dap-vscode-js
    none-ls-extras-nvim
    output-panel-nvim
    playtime-nvim
    vim-arpeggio
    vim-tada
  ];
}
