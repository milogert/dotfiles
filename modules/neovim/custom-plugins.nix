{
  pkgs,
  lib,
  fetchFromGitHub,
  vimUtils,
  rustPlatform,
}:

let
  inherit (pkgs.stdenv) isDarwin;

  bruno-nvim = vimUtils.buildVimPlugin rec {
    pname = "bruno.nvim";
    version = "ad3b2c0039174ac1e7b7247016e95bd7e5d84755";
    src = fetchFromGitHub {
      owner = "romek-codes";
      repo = pname;
      rev = version;
      sha256 = "09ki1dkrk25icq7jz4z3b8ns6jahraydb7bydzm36637r0nzc8li";
    };
    doCheck = false;
  };

  conform-nvim = vimUtils.buildVimPlugin rec {
    pname = "conform.nvim";
    version = "f8929b32acb8712381621b42ef3b0219c3c41efd";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = pname;
      rev = version;
      sha256 = "0m29mrgz1289hjzh3s8068hv5d0ks7rd6mjl715iv1d048d1sp78";
    };
    doCheck = false;
  };

  canola-nvim = vimUtils.buildVimPlugin rec {
    pname = "canola.nvim";
    version = "2a7155060f0667bd7d19c16c931295274059670d";
    src = fetchFromGitHub {
      owner = "barrettruth";
      repo = pname;
      rev = version;
      sha256 = "0vpsdi3nl87kzzi11x3fzgdqvwghxg58s3w1cpgmpblpa8b3iysm";
    };
    # doCheck = false;
  };

  fzf-lua-frecency-nvim = vimUtils.buildVimPlugin rec {
    pname = "fzf-lua-frecency.nvim";
    version = "9ee3d5f023c1a07bc595daf165e6b6be66509a8e";
    src = fetchFromGitHub {
      owner = "elanmed";
      repo = pname;
      rev = version;
      sha256 = "0rpgpsiwl4d18rcazcvb2dq5kxhb25nad6zgjhbpygmalj3y9wzq";
    };
    doCheck = false;
  };

  git-permalink-nvim = vimUtils.buildVimPlugin rec {
    pname = "git-permalink-nvim";
    version = "2d41bacd16370bd4f0e5327e947c70708d6c94df";

    # src = /Users/milo/git/git-permalink-nvim;
    src = fetchFromGitHub {
      owner = "milogert";
      repo = pname;
      rev = version;
      sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
    };
  };

  mcbhub-nvim = vimUtils.buildVimPlugin rec {
    pname = "mcphub.nvim";
    version = "7cd5db330f41b7bae02b2d6202218a061c3ebc1f";

    src = fetchFromGitHub {
      owner = "ravitemer";
      repo = pname;
      rev = version;
      sha256 = "009w7iq31k9sx94p3izqnjbgi0gr9fwn7p5wjcaa3kz16jz4znw3";
    };

    doCheck = false;
  };

  output-panel-nvim = vimUtils.buildVimPlugin rec {
    pname = "output-panel.nvim";
    version = "65bb44a5d5dbd40f3793a8c591b65a0c5f260bd9";
    src = fetchFromGitHub {
      owner = "mhanberg";
      repo = pname;
      rev = version;
      sha256 = "0wpjf25mqlafs0psi5kn3nxn4xnadfpfh9frf0zz8x72qfxkfv8s";
    };
    doCheck = false;
  };

  js-i18n-nvim = vimUtils.buildVimPlugin rec {
    pname = "js-i18n.nvim";
    version = "c1ffe818b08d1f5b1f53c26e7bd9fd9efaafef9e";
    src = fetchFromGitHub {
      owner = "nabekou29";
      repo = pname;
      rev = version;
      sha256 = "sha256-qEYZbnzPrft9lVFtzAjYnVTlc1H95bTlaNLBZmFn2e0=";
    };
    doCheck = false;
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

    cargoHash = "sha256-lMBA8OidN1GGHmIGvJhkLudeEe+RODk1+xdDT2ElEhw=";
    RUSTFLAGS = if isDarwin then "-C link-arg=-undefined -C link-arg=dynamic_lookup" else "";
  };

  lua-json5 = vimUtils.buildVimPlugin rec {
    pname = "lua-json5";
    version = "014fcab8093b48b3932dd0d51ae2d98bbb578d67";
    src = fetchFromGitHub {
      owner = "Joakker";
      repo = pname;
      rev = version;
      sha256 = "sha256-ctLPZzu/lQkVsm+8edE4NsIVUPkr4iTqmPZsCW7GHzY=";
    };

    postInstall =
      if isDarwin then
        "cp ${lua-json5-bin}/lib/liblua_json5.dylib $out/lua/json5.dylib"
      else
        "strip ${lua-json5-bin}/lib/liblua_json5.so -o $out/lua/json5.so";
    doCheck = false;
  };

  none-ls-extras-nvim = vimUtils.buildVimPlugin rec {
    pname = "none-ls-extras.nvim";
    version = "6557f20e631d2e9b2a9fd27a5c045d701a3a292c";
    src = fetchFromGitHub {
      owner = "nvimtools";
      repo = pname;
      rev = version;
      sha256 = "sha256-cd7HJLfLbVs7v+eE+8JrDc0nj/DOGVTbwNEMdZsf2qk=";
    };
    doCheck = false;
  };

  notmuch-nvim = vimUtils.buildVimPlugin rec {
    pname = "notmuch.nvim";
    version = "91acab026b4c0aa790a4bcc34dcdc47077c803b6";
    src = fetchFromGitHub {
      owner = "yousefakbar";
      repo = pname;
      rev = version;
      sha256 = "0xhs80pkrlirw9l3n3yb9zrpdqjb0a8k0afxsaq1jxr9cwgb2glw";
    };
    doCheck = false;
  };

  nvim-dap-vscode-js = vimUtils.buildVimPlugin rec {
    pname = "nvim-dap-vscode-js";
    version = "03bd29672d7fab5e515fc8469b7d07cc5994bbf6";
    src = fetchFromGitHub {
      owner = "mxsdev";
      repo = pname;
      rev = version;
      sha256 = "1nj299by3qs0dbsv1lxb19ia9pbpspw22kdlrilwl8vqixl77ngi";
    };
    doCheck = false;
  };

  playtime-nvim = vimUtils.buildVimPlugin rec {
    pname = "playtime.nvim";
    version = "ab7d232c02341bff8479f532feec5730f8c33770";
    src = fetchFromGitHub {
      owner = "rktjmp";
      repo = pname;
      rev = version;
      sha256 = "0m22lb3nbsr3fs3nx7rxd9acnh9hjr21ayg7b58x5hyhndkfs1w3";
    };
  };

  bloat-nvim = vimUtils.buildVimPlugin rec {
    pname = "bloat.nvim";
    version = "f90bef655ac40fecbaae53e10db1cf7894d090b1";
    src = fetchFromGitHub {
      owner = "dundalek";
      repo = pname;
      rev = version;
      sha256 = "0ah5c84172wkc75zx5ll2dp9y3r867lik29aw5mm7i3lj530p0ri";
    };
  };

  vim-arpeggio = vimUtils.buildVimPlugin rec {
    pname = "vim-arpeggio";
    version = "01c8fc1a72ef58e490ee0490c65ee313b1b6e843";
    src = fetchFromGitHub {
      owner = "kana";
      repo = pname;
      rev = version;
      sha256 = "0405yp1273kzsr3g5j6mj2dfs73qvw716474phkdr67md8ln12dy";
    };
  };

  vim-tada = vimUtils.buildVimPlugin rec {
    pname = "vim-tada";
    version = "625ad428a818041cbbc63e055049108ef5b436a1";
    src = fetchFromGitHub {
      owner = "dewyze";
      repo = pname;
      rev = version;
      sha256 = "1rdfw25lljv53h2f2nc1gmx9awggk7k3nrfj46ssl11jn6lyvbj8";
    };
  };

  yank-path-nvim = vimUtils.buildVimPlugin rec {
    pname = "yank-path.nvim";
    version = "e660248de1e4c91a760f510fc165c172a19cc1d5";
    src = fetchFromGitHub {
      owner = "ywpkwon";
      repo = pname;
      rev = version;
      sha256 = "0pbrfbrdlkgwa55d0sc4q7h5nfdz08h4zza3a0x6b2a2r97159fg";
    };
  };
in
{
  inherit
    nvim-dap-vscode-js
    ;
  list = [
    bloat-nvim
    bruno-nvim
    canola-nvim
    conform-nvim
    fzf-lua-frecency-nvim
    git-permalink-nvim
    js-i18n-nvim
    lua-json5
    mcbhub-nvim
    none-ls-extras-nvim
    notmuch-nvim
    nvim-dap-vscode-js
    output-panel-nvim
    playtime-nvim
    vim-arpeggio
    vim-tada
    yank-path-nvim
  ];
}
