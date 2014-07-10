#!/bin/sh

function copyzsh {
    cp $1/.zshrc ~/.zshrc

    mkdir ~/.zsh
    for file in $(ls $1/.zsh/); do
        cp file ~/.zsh/
    done
}
