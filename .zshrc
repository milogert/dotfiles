#!/bin/zsh

# Loading modules. This should never get changed except in rare cases.
autoload -Uz colors compinit promptinit vcs_info
colors
compinit
promptinit

# zsh history settings.
HISTFILE=~/.zhistfile
HISTSIZE=1000
SAVEHIST=1000

# Other options.
setopt appendhistory autocd completealiases extendedglob nomatch notify prompt_subst
unsetopt beep
bindkey -e
bindkey "^[[3~" delete-char
bindkey "^[3;5~" delete-char

# Command not found bindings.
[ -r /usr/share/doc/pkgfile/command-not-found.zsh ] && . /usr/share/doc/pkgfile/command-not-found.zsh

# Local variables to make color easier.
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
  eval $COLOR='%{$fg_no_bold[${(L)COLOR}]%}'  #wrap colours between %{ %} to avoid weird gaps in autocomplete
  eval BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
eval RESET='$reset_color'

# Source all required files. Each one is divided up according to their
# function.
source ~/.zsh/aliases.sh
source ~/.zsh/style.sh
source ~/.zsh/cmd_settings.sh
source ~/.zsh/functions.sh
source ~/.zsh/prompt.sh
source ~/.zsh/modules.sh
