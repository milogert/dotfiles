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
    alias sysstart='sudo systemctl start $1'
    alias sysstop='sudo systemctl stop $1'
    alias sysrestart='sudo systemctl restart $1'
    alias sysreload='sudo systemctl reload $1'
    alias sysstatus='systemctl status -l $1'
    alias sysenabled='systemctl is-enabled $1'
    alias sysenable='sudo systemctl enable $1'
    alias sysdisable='sudo systemctl disable $1'
    alias sysshutdown='sudo systemctl poweroff'
    alias sysreboot='sudo systemctl reboot'
    alias syssuspend='sudo systemctl suspend'
    alias syshibernate='sudo systemctl hibernate'
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
