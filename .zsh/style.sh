#!/bin/zsh

# Style

# compinstall
zstyle :compinstall filename '/home/milogertjejansen/.zshrc'

# VCS zsh style configuration.
# Backend config.
zstyle ':vcs_info:' enable cvs git svn
zstyle ':vcs_info:*' disable bzr cdv darcs fossil mtn p4 svk tla

# Get the revision for git.
zstyle ':vcs_info:*' get-revision true

# Changes
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%{'${RED}'%}✗'
zstyle ':vcs_info:*' stagedstr '%{'${YELLOW}'%}'

# Formats
# Git specific styles.
zstyle ':vcs_info:git*:*' formats '%c%u %s %{'${BOLD_WHITE}'%}%r:%b%{'${RESET}'%} %.7i'
zstyle ':vcs_info:git*:*' actionformats '%c%u %{'${GREEN}'%}%a %s %r:%b %.7i'

# For bzr, svn, svk, and hg.
zstyle ':vcs_info:*' branchformat '%b@%r'

# For everything else.
zstyle ':vcs_info:*' formats '%u%c|%s:%b'
zstyle ':vcs_info:*' actionformats '%c%u|%s@%a:%b'
