{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Borrowed from https://github.com/nix-community/home-manager/issues/6944
  zshConfigBeforeInit = lib.mkOrder 500 ''
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

  zshConfigAfterInit = lib.mkOrder 1200 ''
    ## initExtra start
    if (( ''${+ZSH_PROFILE} )); then
      echo "Done with performance profile"
      unsetopt XTRACE
      exec 2>&3 3>&-
    fi

    alias ll="${pkgs.eza}/bin/eza -l -g --git --color always --icons -a -s type";
    alias ls="${pkgs.eza}/bin/eza --color auto --icons -a -s type";

    zprof

    if [[ $(uname -s) == 'Darwin' ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    if [[ -d ~/Developer/flutter ]]; then
      export PATH="$PATH:$HOME/Developer/flutter/bin"
    fi

    # cdwt - pushd to a git worktree by branch name
    cdwt() {
      local dir
      dir=$(git worktree list | grep "''${1:?branch name required}" | head -1 | cut -f1 -d' ')
      if [[ -n "$dir" ]]; then
        cd "$dir"
      else
        echo "No worktree found matching '$1'"
        return 1
      fi
    }

    _cdwt() {
      local -a branches
      local line

      while IFS= read -r line; do
        [[ "$line" == branch\ refs/heads/* ]] && branches+=("''${line#branch refs/heads/}")
      done < <(git worktree list --porcelain)

      compadd -- "''${branches[@]}"
    }

    compdef _cdwt cdwt

    # This is generated from `pnpm completion zsh`
    #compdef pnpm
    ###-begin-pnpm-completion-###
    if type compdef &>/dev/null; then
      _pnpm_completion () {
        local reply
        local si=$IFS

        IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "''${words[@]}"))
        IFS=$si

        if [ "$reply" = "__tabtab_complete_files__" ]; then
          _files
        else
          _describe 'values' reply
        fi
      }
      # When called by the Zsh completion system, this will end with
      # "loadautofunc" when initially autoloaded and "shfunc" later on, otherwise,
      # the script was "eval"-ed so use "compdef" to register it with the
      # completion system
      if [[ $zsh_eval_context == *func ]]; then
        _pnpm_completion "$@"
      else
        compdef _pnpm_completion pnpm
      fi
    fi
    ###-end-pnpm-completion-###

    ## initExtra end
  '';
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    dotDir = "${config.xdg.configHome}/zsh";

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

    initContent = lib.mkMerge [
      zshConfigBeforeInit
      zshConfigAfterInit
    ];

    shellAliases = {
      find_aliases = "zsh -ixc : -o sourcetrace 2>&1 | grep -w alias";
      revim = "nvim -c 'lua require(\"persistence\").load()'";
    };

    shellGlobalAliases = {
      G = "| grep";
    };

    prezto = {
      enable = true;
      pmodules = [
        # "prompt"
        "environment"
        # "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        # "wakeonlan"
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
        # theme = "pure";
        # showReturnVal = true;
      };
      color = true;
    };
  };
}
