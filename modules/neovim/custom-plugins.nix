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
      rev = "30f4c0cb37460a82a42e1956eea136bbe10c4417";
      sha256 = "1ykawxi86ax86zqv54qdiaa0g6kx2ii708gcxhvwl70h209frbil";
    };
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

  /* impatient-nvim = pkgs.vimUtils.buildVimPlugin rec { */
  /*   name = "impatient.nvim"; */
  /*   src = pkgs.fetchFromGitHub { */
  /*     owner = "lewis6991"; */
  /*     repo = name; */
  /*     rev = "f4a45e4be49ce417ef2e15e34861994603e3deab"; */
  /*     sha256 = "0q034irf77rlk07fd350zbg73p4daj7bakklk0q0rf3z31npwx8l"; */
  /*   }; */
  /*   # Only skips tests. */
  /*   dontBuild = true; */
  /* }; */

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

  nvim-dev-container = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-dev-container";
    src = pkgs.fetchFromGitHub {
      owner = "esensar";
      repo = name;
      rev = "db519080a3f6e87a10e17f0822eb325532e3dbbc";
      sha256 = "16gpdzyzdvpzffzpkyj4m72zkbimn44daacrbaid4ilg4vfv5k3m";
    };
    # Only skips tests.
    dontBuild = true;
  };

  nvim-remote-containers = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-remote-containers";
    src = pkgs.fetchFromGitHub {
      owner = "jamestthompson3";
      repo = name;
      rev = "d635bea9c24be1656c7e16e4b46ecb39b4b70093";
      sha256 = "04gsz02543q2gi2jqa5hkfmh56vxdll471bp2dm3hlmagv245zfi";
    };
    # Only skips tests.
    dontBuild = true;
  };

  octo-nvim =  pkgs.vimUtils.buildVimPlugin rec {
    name = "octo.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "pwntester";
      repo = name;
      rev = "b33e00cd3066b03164d17e69d7ce9aa656caeda8";
      sha256 = "099vv6ac0zjy0sij00fs1pppj8pa9cy6lvhgw2pq33vpg5c2x7cm";
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
