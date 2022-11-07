{ config, lib, pkgs, ... }:

let
  modules = [
    "neovim"
  ];

  moduleAliasFn = module: {
    "run-${module}" =
      "nix run \"${config.home.homeDirectory}/.dotfiles/modules/${module}#\"";
    "github-${module}" =
      "nix run --no-write-lock-file \"github:milogert/dotfiles#${module}\"";
  };

  moduleAliases = builtins.foldl' (l: r: l // r)  {} (builtins.map moduleAliasFn modules);
in {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;

    localVariables = {
      EDITOR = "nvim";
    };

    profileExtra = ''
      export EDITOR=nvim
    '';

    envExtra = ''
      ## envExtra start
      zmodload zsh/zprof

      [[ -s "''${ZDOTDIR:-$HOME}/.zshenv_priv" ]] && source "''${ZDOTDIR:-$HOME}/.zshenv_priv"

      # Custom dir hashes.
      for parent in git projects; do
        if [[ -d ~/$parent ]]; then
          for i in $(ls ~/$parent); do
            hash -d $i=~/$parent/$i
          done
        fi
      done
      [[ -d ~/.dotfiles ]] && hash -d dotfiles=~/.dotfiles
      ## envExtra end
    '';

    initExtraFirst = ''
      ## initExtraFirst start
      if (( ''${+ZSH_PROFILE} )); then
        echo "Starting performance profile"
        zmodload zsh/datetime
        setopt PROMPT_SUBST
        PS4='+$EPOCHREALTIME %N:%i> '

        logfile=$(mktemp zsh_profile.XXXXXXXX)
        echo "Logging to $logfile"
        exec 3>&2 2>$logfile

        setopt XTRACE
      fi
      ## initExtraFirst end
    '';

    initExtra = ''
      ## initExtra start
      if (( ''${+ZSH_PROFILE} )); then
        echo "Done with performance profile"
        unsetopt XTRACE
        exec 2>&3 3>&-
      fi

      alias ll="exa -l -g --git --color always --icons -a -s type";
      alias ls="exa --color auto --icons -a -s type";

      # Functions
      modrun() {
        echo "Running module in ''$HOME/.dotfiles/modules/''$1#"
        nix run "''$HOME/.dotfiles/modules/''$1#"
      };

      #zprof
      ## initExtra end
    '';

    shellAliases = {
      find_aliases = "zsh -ixc : -o sourcetrace 2>&1 | grep -w alias";
      revim = "nvim -c 'lua require(\"persistence\").load()'";
    } // moduleAliases;

    shellGlobalAliases = {
      G = "| grep";
    };

    prezto = {
      enable = true;
      pmodules = [
        /* "prompt" */
        "environment"
        /* "terminal" */
        "editor"
        "history"
        "directory"
        "spectrum"
        /* "wakeonlan" */
        "docker"
        "git"
        "utility"
        "completion"
      ];
      terminal.autoTitle = true;
      editor.dotExpansion = true;
      prompt = {
        # Use starship here.
        theme = "none";
        /* theme = "pure"; */
        /* showReturnVal = true; */
      };
      color = true;
    };
  };
}
