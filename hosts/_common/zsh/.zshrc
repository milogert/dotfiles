if (( ${+ZSH_PROFILE} )); then
  echo "Starting performance profile"
  zmodload zsh/datetime
  setopt PROMPT_SUBST
  PS4='+$EPOCHREALTIME %N:%i> '

  logfile=$(mktemp zsh_profile.XXXXXXXX)
  echo "Logging to $logfile"
  exec 3>&2 2>$logfile

  setopt XTRACE
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Virtualenv stuff.
if [ -f /usr/bin/virtualenvwrapper.sh ]
then
    source /usr/bin/virtualenvwrapper.sh
    export WORKON_HOME=~/.virtualenvs
fi

# Java home for OS X.
#if [ -f /usr/libexec/java_home ]
#then
    #export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
    #export JAVA_HOME=$(/usr/libexec/java_home -v 11)
#fi

if [ -d ~/scripts/grinder ]
then
    alias startgrinder="java -cp ~/scripts/grinder/lib/grinder.jar  net.grinder.TCPProxy -remoteport 55555 -localport 5050 -colour"
fi

# Bind the proper keys for the numpad.
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

# Logbook.
function lb() {
    b=~/logbook/$(date '+%Y-%m-%d').md
    if [ ! -f ${b} ]; then
        echo "vi: nonumber norelativenumber wrap linebreak nolist\n\n# MM\n\n" > ${b}
    fi
    ${EDITOR} "+normal G$" ${b}
}

# opam configuration
test -r /home/milo/.opam/opam-init/init.zsh && . /home/milo/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# embed cheat.sh!
function cheat(){
    curl https://cheat.sh/$@
}
export cheat

[[ -f ~/scripts/aliases.sh ]] && source ~/scripts/aliases.sh

if (( ${+ZSH_PROFILE} )); then
  echo "Done with performance profile"
  unsetopt XTRACE
  exec 2>&3 3>&-
fi

alias mux=tmuxinator


# Rusty tools: https://dev.to/22mahmoud/my-terminal-became-more-rusty-4g8l
if [ "$(command -v exa)" ]; then
  unalias -m 'll'
  unalias -m 'l'
  unalias -m 'la'
  unalias -m 'ls'
  alias ls='exa -G  --color auto --icons -a -s type'
  alias ll='exa -l -g --git --color always --icons -a -s type'
fi

# Starship prompt
# Docs: https://starship.rs/config/#command-duration
if [ "$(command -v starship)" ]; then
  eval "$(starship init zsh)"
fi

if [ "$(command -v bat)" ]; then
  export BAT_THEME="ansi-dark"
  theme='ansi-dark'
  unalias -m 'cat'
  #alias cat="bat --theme='${theme}'"
  #alias catt="bat --style=plain --pager=never --theme='${theme}'"
  alias cat="bat"
  alias catt="bat --style=plain --pager=never"
fi

export PATH="/usr/local/opt/node@14/bin:/usr/local/opt/gnupg@2.2/bin:$PATH"
