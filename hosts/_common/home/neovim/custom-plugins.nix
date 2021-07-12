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
}
