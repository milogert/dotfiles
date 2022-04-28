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
      rev = "a6dc35750e7ba6926e79d006b9e0585dc74cf93c";
      sha256 = "16akr3i977618acy7f4k53iahspm6rbr79b56ybbhayk90mvb8f5";
    };
  };

  copilot-cmp = pkgs.vimUtils.buildVimPlugin rec {
    name = "copilot-cmp";
    src = pkgs.fetchFromGitHub {
      owner = "zbirenbaum";
      repo = name;
      rev = "03dfaf106aa7727354684f697074805a7bb7515d";
      sha256 = "1vi3h80qnawz189hh6xcb9d99myqaq6r9iq5qj2za3pyr9n26q5v";
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
      rev = "93c75cbe231573fe43bfb8f98491a83dfe44d504";
      sha256 = "17hngyd2hcm902ra1xl28sl3b01syfgn9n7brammsikklby04nqm";
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
      rev = "88e44bbbe2e03523e08f2bd3c9a954675bc438f4";
      sha256 = "16sqmc484q2jlzy4mq1zh01ymvx01z66l70fn2nd4x3mmnx8agdy";
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
