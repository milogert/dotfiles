{ fetchgit, fetchFromGitHub, pkgs }:

{
  # git-permalink-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "git-permalink-nvim";
  #   src = /Users/milo/git/git-permalink-nvim;
  # };

  git-permalink-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "git-permalink-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "milogert";
      repo = name;
      rev = "2d41bacd16370bd4f0e5327e947c70708d6c94df";
      sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
    };
  };


  # art-nvim = pkgs.vimUtils.buildVimPlugin {
  #   name = "art-nvim";
  #   src = /Users/milo/projects/art-nvim;
  # };

  art-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "art-nvim";
    src = builtins.fetchGit {
      url = "git@github.com:articulate/art-nvim.git";
      rev = "33b19e043cefb7a7db9bc9378efda2a6eaa9fd83";
    };
  };

  heirline-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "heirline.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = name;
      rev = "2aed06a3a04c877dc64834e9b9dabf6ad3491bc8";
      sha256 = "1sqhnhc749hm1bpy6s49w8jb3zpzj2azpj2hszn13ml1g1ps5iv7";
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

  mason-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "mason.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "williamboman";
      repo = name;
      rev = "beb79ced9e49ea1ce2bd170b79e0cf819a8377c7";
      sha256 = "0qcfl8qvj0y1qw6pqpasrxy5ji7rxnns2bmbr8hgjnpqgnp8rryz";
    };
    # Only skips tests.
    dontBuild = true;
  };

  mason-lspconfig-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "mason-lspconfig.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "williamboman";
      repo = name;
        rev = "d7ff61a828d59bc593ea3e2020508c114048d790";
        sha256 = "03rmdhp30kzvc98gaagxbm3cm0q1mqy28wjih6r7l14kp3qv8bv1";
      };
    # Only skips tests.
    dontBuild = true;
  };

  nvim-dev-container = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-dev-container";
    src = pkgs.fetchgit {
      url = "https://codeberg.org/esensar/${name}";
      rev = "4b61c02417debde53dc6445941c5a3be7d05e990";
      sha256 = "1l269qy4v3qiaxwkjd3s5bfa4zwld67aaxb9qa9ay8mgmz5hdh27";
    };
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

  srcery-vim = pkgs.vimUtils.buildVimPlugin rec {
    name = "srcery-vim";
    src = pkgs.fetchFromGitHub {
      owner = "srcery-colors";
      repo = name;
      rev = "7af46a5b032e3275dc6d3c993d72fb290d51f74d";
      sha256 = "1v5xld3v3i7i2xkp3r1nqcghriikpb2ak7d0a021hjbasm74fbgc";
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

  vim-ai = pkgs.vimUtils.buildVimPlugin rec {
    name = "vim-ai";
    src = pkgs.fetchFromGitHub {
      owner = "madox2";
      repo = name;
      rev = "6ae66e51f29c60537b7e931f85cc6f452b6cc651";
      sha256 = "1q9xvl99r1ar6j7bwq9hwdm5rsp239dgha8ljl15dwqfldr3p4w8";
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
