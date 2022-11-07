{ fetchFromGitHub, pkgs }:

{
  # These plugins exist in the store but I want to override them for one
  # reason or another.
  overrides = {
    nvim-colorizer-lua = pkgs.vimUtils.buildVimPlugin rec {
      name = "nvim-colorizer.lua";
      src = pkgs.fetchFromGitHub {
        owner = "NvChad";
        repo = name;
        rev = "004a2b3ef62b01d3d1db454d1efe76d31934d43b";
        sha256 = "0ya9qnp294lldarab7cc6fddjc3wad8zsqn2bl9b4dlypgcz7g1g";
      };
    };

    # nvim-treesitter = pkgs.vimUtils.buildVimPlugin rec {
    #   name = "nvim-treesitter";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "nvim-treesitter";
    #     repo = name;
    #     rev = "09b13e9edb80d3890aa8f7dbebfdb21e34430212";
    #     sha256 = "1c17j81crh238xykmimdnlfm45lgah4iaw7c5rhf759d0xpn1c6v";
    #   };
    #   # Only skips tests.
    #   dontBuild = true;
    # };
  };

  copilot-lua = pkgs.vimUtils.buildVimPlugin rec {
    # This one is special. Needs no name prefix because it tries to find itself
    # in the pack path.
    namePrefix = "";
    name = "copilot.lua";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = name;
      rev = "0dfa2b5434a09d795e304721b08503c96ce9b314";
      sha256 = "1ah911l8ncbl4vzbngmkdvg1p49yajr95i8jy153ws70qf7scis2";
    };
  };

  copilot-cmp = pkgs.vimUtils.buildVimPlugin rec {
    name = "copilot-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = name;
      rev = "a3ea9493c9c9385dcb78cb0b3db4b86708232504";
      sha256 = "1i32bsf7gs5j1hvj2a7jnc5asps7bg9znv9qwmx9846pr2z92i54";
    };
  };

  fzf-lua = pkgs.vimUtils.buildVimPlugin rec {
    name = "fzf-lua";
    src = pkgs.fetchFromGitHub {
      owner = "ibhagwan";
      repo = name;
      rev = "0e0bc7a6009059da25078ec1eb551dc8f87d219b";
      sha256 = "0ap40l3dcdj8qya4cpyvgh5zdak20bbr7vv77pss8z0cvqpzv9r5";
    };
    # Only skips tests.
    dontBuild = true;
  };

  heirline-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "heirline.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "rebelot";
      repo = name;
      rev = "08a9c4eaeb8da53b8f68279f5d6ba2b98bfd885b";
      sha256 = "02dg04l3sih0rfr7pvk3rqngb1386hbhl6bj5ibfwlmf74zaf20f";
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

  nvim-navic = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-navic";
    src = pkgs.fetchFromGitHub {
      owner = "SmiteshP";
      repo = name;
      rev = "3ab0c97e4b5ad4c2f5dbe6bd96366d24a8fc75f6";
      sha256 = "1x3lv4j7m4y53ghqdgx2jy6ysyd67y0spjakw0h4mh3jv64sbphk";
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
      rev = "77cf5a6ee162013b97237ff25450080401849f85";
      sha256 = "19wgihch5ypa08pscsqd01cixmgbnkcvsgapq6xh9bdcp59fcji4";
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
      rev = "acfda7229fc487ee6da44650164cb770d1cc608c";
      sha256 = "0rjhbxpma8k6fgn5wm66bf01f22fr6g89rmmim9x13nm79pwnjzn";
    };
  };
}
