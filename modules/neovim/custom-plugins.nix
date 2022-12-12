{ fetchFromGitHub, pkgs }:

{
  heirline-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "heirline.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = name;
      rev = "a94390e0e8509944bfbd8265a5b4bb231d2d2954";
      sha256 = "00c0835l9vhbwndyfmk43jig08y425w3hl4lb2bssdqc0fca4ddc";
    };
  };

  hydra-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "hydra.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "anuvyklack";
      repo = name;
      rev = "a815ce78805a5667e81cdb53d2bc7e0371042a7a";
      sha256 = "0i5ksipnk22k1dps0hg6qn3y3bx0qx0rr86irzd8dga415da0wdi";
    };
  };

  nvim-lsp-installer = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-lsp-installer";
    src = pkgs.fetchFromGitHub {
      owner = "williamboman";
      repo = name;
      rev = "8603cdc1692f2c3078e328a2ed9554cf9047594d";
      sha256 = "0rwnm9bvd8gf5ipg7mbysbs13dzi0ijjarv3x4a9czmgc4b48h7q";
    };
    # Only skips tests.
    dontBuild = true;
  };

  nvim-runscript = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-runscript";
    src = pkgs.fetchFromGitHub {
      owner = "klesh";
      repo = name;
      rev = "fd0b3d008a32499f73d0a160612b39f33325f85f";
      sha256 = "1mys3rzg3wxjmxrg13p6hvw7gwk8wi3mi8h7haswy0239kkpaz27";
    };
  };

  persistence-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "persistence.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = name;
      rev = "251e89523dabc94242d4a1f2226fc44a95c29d9e";
      sha256 = "1xbly3hfbll5r05sznhn8dd1g653yz7hy3xl36yix82sdhx26v84";
    };
  };

  sibling-swap-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "sibling-swap.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Wansmer";
      repo = name;
      rev = "71eb9daa5233cd576ce8119bc2dbfa67d4d35462";
      sha256 = "070amb0rrl77bi5yrfgl16s96hw7w8hm2v9pm2caky8fh1kq44gk";
    };
  };

  vim-arpeggio = pkgs.vimUtils.buildVimPlugin rec {
    name = "vim-arpeggio";
    src = pkgs.fetchFromGitHub {
      owner = "kana";
      repo = name;
      rev = "01c8fc1a72ef58e490ee0490c65ee313b1b6e843";
      sha256 = "0405yp1273kzsr3g5j6mj2dfs73qvw716474phkdr67md8ln12dy";
    };
  };

  vim-tada = pkgs.vimUtils.buildVimPlugin rec {
    name = "vim-tada";
    src = pkgs.fetchFromGitHub {
      owner = "dewyze";
      repo = name;
      rev = "625ad428a818041cbbc63e055049108ef5b436a1";
      sha256 = "1rdfw25lljv53h2f2nc1gmx9awggk7k3nrfj46ssl11jn6lyvbj8";
    };
  };
}
