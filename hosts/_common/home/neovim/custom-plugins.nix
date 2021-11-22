{ fetchFromGitHub, pkgs }:

{
  alpha-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "alpha-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "goolord";
      repo = name;
      rev = "7a49086bf9197f573b396d4ac46262c02dfb9aec";
      sha256 = "0qfxyf25yw5yrxrmbsi0gbd0bhzpmsw9ls4blhhb8q1jpkvbcmgw";
    };
  };

  cmp_luasnip = pkgs.vimUtils.buildVimPlugin rec {
    name = "cmp_luasnip";
    src = pkgs.fetchFromGitHub {
      owner = "saadparwaiz1";
      repo = name;
      rev = "16832bb50e760223a403ffa3042859845dd9ef9d";
      sha256 = "0hc6flnvdgd7a93p8y9msp92bc1r10nh00wvw9msr40442m8viqc";
    };
  };

  copilot-vim = pkgs.vimUtils.buildVimPlugin rec {
    name = "copilot.vim";
    src = pkgs.fetchFromGitHub {
      owner = "github";
      repo = name;
      rev = "e1be74e21a7daf88ca52116386c5acdb22265c76";
      sha256 = "01m2xqibxl9p27zhyx86rjrihm90jla7pbsnqgjzgm3hyg8fp1g8";
    };
  };

  impatient-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "impatient.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "lewis6991";
      repo = name;
      rev = "f4a45e4be49ce417ef2e15e34861994603e3deab";
      sha256 = "0q034irf77rlk07fd350zbg73p4daj7bakklk0q0rf3z31npwx8l";
    };
    # Only skips tests.
    dontBuild = true;
  };

  LuaSnip = pkgs.vimUtils.buildVimPlugin rec {
    name = "LuaSnip";
    src = pkgs.fetchFromGitHub {
      owner = "L3MON4D3";
      repo = name;
      rev = "366fd76ea226bed11966cd8b1a229cba08fa4394";
      sha256 = "17jla5yvi0vzgi0himl8fyfmc8sl8xg1k5bzl58iq0d2ycmr08as";
    };
    # Only skips tests.
    dontBuild = true;
  };

  nui-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "nui.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "MunifTanjim";
      repo = name;
      rev = "dbe08f29529b6b30e793718fd45eaa4e484410e8";
      sha256 = "02g46p0290yrhzbx63gzk95myc7y2v2bh9c66nfzryfdc728i113";
    };
  };

<<<<<<< HEAD
  octo-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "octo.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "pwntester";
      repo = "octo.nvim";
      rev = "848990b8d7f7f28293cfb5a1ad19abf66e27f08a";
      sha256 = "09ibp9m47jinzjvs7ql5hvmavcg46hgyyhn8907w3dr8snadrwgs";
    };
  };

  package-info-nvim = pkgs.vimUtils.buildVimPlugin {
=======
  nvim-lsp-installer = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-lsp-installer";
    src = pkgs.fetchFromGitHub {
      owner = "williamboman";
      repo = name;
      rev = "35d4b08d60c17b79f8e16e9e66f0d7693c99d612";
      sha256 = "1zf9r6qg8s8zz2n63fmz01xphvyz1jxg1bqy4mdlglj2h16i2jpj";
    };
  };

  nvim-treesitter = pkgs.vimUtils.buildVimPlugin rec {
    pname = "nvim-treesitter";
    version = "2021-11-14";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = pname;
      rev = "a47df48e7d4232fd771f2537a4fb43f582c026c9";
      sha256 = "0w3v6416b8a7y20awjdkh9ag3xrnqyg2va25nvv9d8n4zw2aqp02";
    };
  };

  package-info-nvim = pkgs.vimUtils.buildVimPlugin rec {
>>>>>>> dcfb765fd3061d1ef96b4698ec9d932e84a3493b
    name = "package-info.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "vuki656";
      repo = name;
      rev = "7f5d4f8583de1eaf1ae998c369cb1c81565205d7";
      sha256 = "1xmxkzwspi10417jvnwc50vd56s9bn8f1604ag8vzb7i6mxl2s79";
    };
  };

  persistence-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "persistence.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = name;
      rev = "2f2b0cc69d13a91b6ec2d72de882586dceae19bb";
      sha256 = "10bjvpbi9bmpiy8zr76xaab223yh023lqkq1v0dcfnqx5v4caw17";
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
}
