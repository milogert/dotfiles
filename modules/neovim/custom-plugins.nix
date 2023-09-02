{ fetchgit, fetchFromGitHub, pkgs }:

let
  art-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "art-nvim";
    src = builtins.fetchGit {
      url = "git@github.com:articulate/art-nvim.git";
      rev = "33b19e043cefb7a7db9bc9378efda2a6eaa9fd83";
    };
  };

  git-permalink-nvim = pkgs.vimUtils.buildVimPlugin rec {
    name = "git-permalink-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "milogert";
      repo = name;
      rev = "2d41bacd16370bd4f0e5327e947c70708d6c94df";
      sha256 = "0d9r4p4a8dms9k01ayvdgppy96ds8pnbq38r1kvjw7m9a7qg1rr4";
    };
  };

  nvim-dev-container = pkgs.vimUtils.buildVimPlugin rec {
    name = "nvim-dev-container";
    src = pkgs.fetchgit {
      url = "https://codeberg.org/esensar/${name}";
      rev = "5cbc8c961779c12e366692780d387a2c7c8dff57";
      sha256 = "sha256-K8xnWvK+ZVCHNA8GtNbefous39HeAScTm5FWow2B4E8=";
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
in [
  art-nvim
  git-permalink-nvim
  nvim-dev-container
  nvim-runscript
  vim-ai
  vim-arpeggio
  vim-tada
]
