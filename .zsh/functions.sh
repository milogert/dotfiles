#!/bin/zsh

# Collapse the pwd to home. Deprected with ${PWD/#$HOME/~}
function collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

# Decompress everything and anything.
function extract {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xvjf "$1";;
            *.tar.gz) tar xvjf "$1";;
            *.bz2) bunzip2 "$1";;
            *.rar) unrar x "$1";;
            *.gz) gunzip "$1";;
            *.tar) tar xvf "$1";;
            *.tbz2) tar xvjf "$1";;
            *.tgz) tar xvzf "$1";;
            *.zip) unzip "$1";;
            *.Z) uncompress "$1";;
            *.7z) 7z x "$1";;
            *)
                echo "'$1' cannot be extracted."
                return 1
                ;;
        esac
    else
        echo "'$1' is not a valid file."
        return 1
    fi
    return 0
}

# Used to find return codes of urls in a list of them.
function find_url_codes {
    if [ $# -lt 2 ]; then
        echo "Usage: find_url_codes urlfile outfile"
    else
        while read line; do
            wget -q --spider $line
            echo "${?} -> ${line}" >> $2
        done < $1
    fi
}

# Git prompt, if there is one.
#function git_prompt {
#    ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
#    echo ''
#}

# Lazy tmux.
function ltm {
    if tmux has-session -t $USER; then
        tmux attach -t $USER;
    else
        tmux new -s $USER;
    fi
}

# Make a directory and move into it.
function mkcd {
    mkdir $1
    cd $1
}

# Determines prompt character.
#function prompt_char {
#    git branch >/dev/null 2>/dev/null && echo '±' && return
#    echo 'o'
#}

# Realoads zsh configuration.
function rz {
    source ~/.zshrc
    echo ".zshrc reloaded!"
}

function swap() {
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function title() {
    # escape '%' chars in $1, make nonprintables visible
    local a=${(V)1//\%/\%\%}

    # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")
    case $TERM in
    screen*)
        print -Pn "\e]2;$a @ $2\a" # plain xterm title
        print -Pn "\ek$a\e\\"      # screen title (in ^A")
        print -Pn "\e_$2   \e\\"   # screen location
        ;;
    xterm*)
        print -Pn "\e]2;$a @ $2\a" # plain xterm title
        ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "%m:%55<...<%~"
    vcs_info "rprompt"
}

# preexec is called just before any command line is executed
function preexec() {
    title "$1" "%m:%35<...<%~"
}

# Virtual environment prompt function.
function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]] then
        echo ''
    else
        echo "(${VIRTUAL_ENV##*/}) "
    fi
}

function veactivate {
  export VIRTUAL_ENV_DISABLE_PROMPT='1'
  source ./$1/bin/activate
}


