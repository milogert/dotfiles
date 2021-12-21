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

  nvim-lsp-installer = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-lsp-installer";
    src = pkgs.fetchFromGitHub {
      owner = "williamboman";
      repo = name;
      rev = "35d4b08d60c17b79f8e16e9e66f0d7693c99d612";
      sha256 = "1zf9r6qg8s8zz2n63fmz01xphvyz1jxg1bqy4mdlglj2h16i2jpj";
    };
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
