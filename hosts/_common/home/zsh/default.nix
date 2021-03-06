{ config, pkgs, ... }:

let
  xdg = import ../xdg.nix { inherit config; };
in rec {
  inherit xdg;
  home.file = {
    # Need to find a way around this: I can't commit this file but nix won't
    # let me import it unless it's in the repo
    #".zshrc_priv".source = ./.zshrc_priv;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    autocd = true;

    localVariables = {
      EDITOR = "nvim";
    };

    envExtra = ''
      ## envExtra start
      if [[ -s "''${ZDOTDIR:-$HOME}/.zshenv_priv" ]]; then
        source "''${ZDOTDIR:-$HOME}/.zshenv_priv"
      fi

      # Custom dir hashes.
      if [[ -d ~/git ]]; then
        for i in $(ls ~/git); do
          hash -d $i=~/git/$i
        done
      fi
      [[ -d ~/.zprezto ]] && hash -d zsh=~/.zprezto
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
      ## initExtra end
    '';

    shellGlobalAliases = {
      G = "| grep";
    };

    prezto = {
      enable = true;
      # Use starship here.
      prompt = {
        theme = "off";
      };
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "wakeonlan"
        "utility"
        "completion"
        "docker"
        "git"
      ];
      terminal.autoTitle = true;
      editor.dotExpansion = true;
      #prompt = {
      #  showReturnVal = true;
      #};
      color = true;
      #pmoduleDirs = [ "$HOME/.zprezto-contrib" ];
    };
  };
}
