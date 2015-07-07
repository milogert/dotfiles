#!/bin/zsh

# Settings for commands.
ulimit -c unlimited     # Coredump size for c++.
if [ -e /usr/bin/dircolors ]; then
    eval $(dircolors -b)
elif [[ $(uname -a) == *Darwin* ]]; then
    export CLICOLOR=1
    export LSCOLORS=ExFxCxDxCxegedabagaced
fi

# Setting for the java home.
if [ -e /usr/libexec/java_home ]; then
  export JAVA_HOME="`/usr/libexec/java_home -v '1.7'`"
fi

# Declares the display, if necessary.
if [[ $(uname) == CYGWIN* ]]; then
    export DISPLAY=localhost:0.0
fi

# Create suitable path.
if [ -d /home/milo/.gem/ruby/1.9.1/bin ]; then
    PATH=$PATH:/home/milo/.gem/ruby/1.9.1/bin
fi

# If go is installed.
if [ -d $HOME/go ]; then
  export GOPATH=$HOME/go
  PATH=$PATH:$GOPATH/bin
fi

# If the android sdk tools are installed.
if [ -d /opt/android-sdk/platform-tools ]; then
  PATH=$PATH:/opt/android-sdk/platform-tools;
fi

# Things to export.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export EDITOR=/usr/bin/vim
export GNUSTEP_USER_ROOT=~/GNUstep
export GREP_COLOR='1;33'
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
export PGROOT=/var/lib/postgres
#export VIRTUAL_ENV_DISABLE_PROMPT=yes
export MODULES=~/.zsh/modules

# Export the path.
export PATH
