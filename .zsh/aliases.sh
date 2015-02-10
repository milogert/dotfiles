#!/bin/zsh

# Aliases

# Yaourt aliases.
if [ -e /usr/bin/yaourt ]; then
    alias yoin='yaourt'
    alias youpg='yaourt -Syu'
    alias youpga='yaourt -Syua'
    alias yorem='yaourt -Rns'
fi

# MTU aliases.
if [[ $(uname -a) == *mtu* ]]; then
    alias subl='~/subl/sublime_text'
fi

# Elevated commands (power, daemons, etc.)
if [ $UID -ne 0 ] && [ -e /usr/bin/systemctl ]; then
    alias start='sudo systemctl start $1'
    alias stop='sudo systemctl stop $1'
    alias restart='sudo systemctl restart $1'
    alias reload='sudo systemctl reload $1'
    alias status='systemctl status $1'
    alias is-enabled='systemctl is-enabled $1'
    alias enable='sudo systemctl enable $1'
    alias disable='sudo systemctl disable $1'
    alias shutdown='sudo systemctl poweroff'
    alias reboot='sudo systemctl reboot'
    alias suspend='sudo systemctl suspend'
    alias hibernate='sudo systemctl hibernate'
fi

# Safety features
if [[ $(uname -a) != *Darwin* ]]; then
    alias cp='cp -i'
    alias mv='mv -i'
    alias rm='rm -I'
    alias ln='ln -i'
    alias chown='chown --preserve-root'
    alias chmod='chmod --preserve-root'
    alias chgrp='chgrp --preserve-root'
fi

# Colored commands
if [[ $(uname -a) != *Darwin* ]]; then
    alias ls='ls --color -Fh'
else
    alias ls='ls -GFh'
fi

alias grep='grep --color=auto'

# tmux Related.
if [ -e /usr/bin/tmux ]; then
    alias attach='tmux attach -t $1'
    alias new='tmux new -s $1'
fi

# Others
if [ -e /usr/bin/colordiff ]; then
    alias diff='colordiff'
fi
alias df='df -h'
alias hist='history | grep $1'
alias mkdir='mkdir -p -v'
if [[ $(uname -a) == *Darwin* ]]; then
    alias mysql="/usr/local/mysql/bin/mysql"
fi
alias nano='nano -w'
if [[ $(uname -a) != *Cygwin* ]]; then
    alias ping='ping -c 4'
fi
alias ssh='ssh -X'
