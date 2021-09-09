{ fetchFromGitHub, pkgs }:

{
  vim-arpeggio = pkgs.vimUtils.buildVimPlugin {
    name = "vim-arpeggio";
    src = pkgs.fetchFromGitHub {
      owner = "kana";
      repo = "vim-arpeggio";
      rev = "01c8fc1a72ef58e490ee0490c65ee313b1b6e843";
      sha256 = "0405yp1273kzsr3g5j6mj2dfs73qvw716474phkdr67md8ln12dy";
    };
  };

  vim-nuuid = pkgs.vimUtils.buildVimPlugin {
    name = "vim-nuuid";
    src = pkgs.fetchFromGitHub {
      owner = "kburdett";
      repo = "vim-nuuid";
      rev = "6abc11a7943e5777c27b6271f3b6243f426d68fd";
      sha256 = "1yx3c6fgq8paa3mxzrzi61alvsvjyqihrlla2ip8fqmxd420vjsx";
    };
  };

  any-jump-vim = pkgs.vimUtils.buildVimPlugin {
    name = "any-jump.vim";
    src = pkgs.fetchFromGitHub {
      owner = "pechorin";
      repo = "any-jump.vim";
      rev = "c5c319fdf588c9ed53e6a32eb2608bd1eb2f9c92";
      sha256 = "1lzpr5x7zvpc252j6ipp2rfjfd25a0mrkikq8vdsbxbamp8cyqpb";
    };
  };

  nvim-treesitter = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-treesitter";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-treesitter";
      repo = "nvim-treesitter";
      rev = "c37e79803e21abfae960174a6c661da166c87e8b";
      sha256 = "1dd4qmv6yrmx1b5qdz5yc5sipgag3qkgrkkw0y7wnvvw42vgz916";
    };
  };

  wilder-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "wilder.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "gelguy";
      repo = "wilder.nvim";
      rev = "a8a2feda01b8d498b49ef133f648297959de2fa8";
      sha256 = "0sbcgv6zw9i7mv8plv7kr14zpvd24wlbgpx1k0hdfs3wbb8md9ya";
    };
  };

  persistence-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "persistence.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "persistence.nvim";
      rev = "2f2b0cc69d13a91b6ec2d72de882586dceae19bb";
      sha256 = "10bjvpbi9bmpiy8zr76xaab223yh023lqkq1v0dcfnqx5v4caw17";
    };
  };

}
