{ pkgs
, ...
}:

{
  home.packages = with pkgs; [
    gh
    gitAndTools.delta
    gitAndTools.gh
  ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName  = "Milo Gertjejansen";
    userEmail = "milo@milogert.com";

    signing = {
      # NOTE: `key` is set by user home files
      signByDefault = true;
      gpgPath = "gpg";
    };

    aliases = {
      a = "add";
      amend = "commit --amend";
      branches = "for-each-ref --sort=-committerdate --format='%(color:cyan)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)' refs/remotes";
      c = "commit";
      ca = "commit --amend";
      ci = "commit -a";
      co = "checkout";
      d = "diff";
      dc = "diff --changed";
      ds = "diff --staged";
      f = "fetch";
      loll = "log --abbrev-commit --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --";
      m = "merge";
      one = "log --pretty=oneline";
      outstanding = "rebase -i @{u}";
      praise = "blame";
      s = "status";
      sw = "switch";
      unpushed = "log @{u}";
      wc = "whatchanged";
      #wip = "rebase -i @{u}";
      wip = "for-each-ref --sort='authordate:iso8601' --format=' %(color:green)%(authordate:relative)%09%(color:white)%(refname:short)' refs/heads";
      zap = "fetch -p";
    };

    extraConfig = {

      core = {
        editor = "nvim";
        excludesfile = "$HOME/.config/git/ignore";
        #hooksPath = "$HOME/.config/git/hooks";
        pager = "delta";
      };

      color.ui = true;
      commit.verbose = true;
      fetch.prune = true;
      grep.lineNumber = true;
      help.autocorrect = 1;
      interactive.diffFilter = "delta --dark --color-only";
      pull.rebase = false;
      push.default = "upstream";

      delta = {
        features = "decorations";
        line-numbers = true;
        whitespace-error-style = "22 reverse";
        syntax-theme = "srcery";
      };

      "delta \"decorations\"" = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "none";
        hunk-header-decoration-style = "yellow box";
      };
    };
  };
}
