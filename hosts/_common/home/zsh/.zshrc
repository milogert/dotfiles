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

# embed cheat.sh!
function cheat(){
    curl https://cheat.sh/$@
}
export cheat

# Starship prompt
# Docs: https://starship.rs/config/#command-duration
# if [ "$(command -v starship)" ]; then
#   echo "fake starship init"
# fi
