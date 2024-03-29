{ pkgs
, config
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

    aliases = {
      a = "add";
      amend = "commit --amend";
      branches = "for-each-ref --sort=-committerdate --format='%(color:cyan)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)' refs/remotes";
      c = "commit";
      ca = "commit --amend";
      ci = "commit -a";
      cp = "commit --amend --no-edit";
      co = "checkout";
      d = "diff";
      dc = "diff --changed";
      ds = "diff --staged";
      f = "fetch";
      ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
      loll = "log --abbrev-commit --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --";
      m = "merge";
      one = "log --pretty=oneline";
      outstanding = "rebase -i @{u}";
      pb = "!git add package.json yarn.lock && git commit -m \"Package bump\" && git push";
      praise = "blame";
      s = "status";
      sw = "switch";
      unpushed = "log @{u}";
      wc = "whatchanged";
      #wip = "rebase -i @{u}";
      wipp = "for-each-ref --sort='authordate:iso8601' --format=' %(color:green)%(authordate:relative)%09%(color:white)%(refname:short)' refs/heads";
      wip = "!git wipp | fzf --tac --bind 'enter:execute(git checkout {-1})+abort'";
      zap = "fetch -p";
    };

    ignores = [
      "*~"
      ".DS_Store"
      ".idea"
      ".vscode"
      "node_modules"
    ];

    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = "$HOME/.config/git/ignore";
        #hooksPath = "$HOME/.config/git/hooks";
        pager = "delta";
      };

      color.ui = true;
      commit.verbose = true;
      diff.algorithm = "histogram";
      fetch.prune = true;
      grep.lineNumber = true;
      help.autocorrect = 1;
      init.defaultBranch = "main";
      interactive.diffFilter = "delta --dark --color-only";
      merge.conflictStyle = "zdiff3";
      pull.rebase = false;
      push.autoSetupRemote = true;
      push.default = "upstream";

      # url."git@github.com".insteadOf = "https://github.com";

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

  home.activation.requestReadProjectForGH =
    let
      gh = "${pkgs.gh}/bin/gh";
    in
      config.lib.dag.entryAfter ["writeBoundary"] ''
        if (! ${gh} auth status); then
          run ${gh} auth login -s read:project
        fi
      '';
}
