#!/bin/bash

# bash_prompt

# Example:
# thompsongl@gregorys-mbp: ~/src/dotfiles (boxen)[+!?$]
# $

get_git_branch() {
    local branch_name

    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"

    printf $branch_name
}
prompt_git() {
    local s=""
    local branchName=""

    # check if the current directory is in a git repository
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; printf "%s" $?) == 0 ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == "false" ]; then

            # ensure index is up to date
            git update-index --really-refresh  -q &>/dev/null

            # check for uncommitted changes in the index
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s="$s+";
            fi

            # check for unstaged changes
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s="$s!";
            fi

            # check for untracked files
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s="$s?";
            fi

            # check for stashed files
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s="$s$";
            fi

        fi

        # get the short symbolic ref
        # if HEAD isn't a symbolic ref, get the short SHA
        # otherwise, just give up
        branchName=$(get_git_branch)

        [ -n "$s" ] && s="[$s]"

        printf "%s" "$1($branchName)$s"
    else
        return
    fi
}
function EXT_COLOR () { echo -ne "\[\033[38;5;$1m\]"; }
GRAY="`EXT_COLOR 242`"
RESET="\[\033[0m\]"
PS1="\n" # Newline
PS1+="${GRAY}\u" # Username
PS1+="${GRAY}@" # @
PS1+="${GRAY}\h" # Host
PS1+="${GRAY}: " # :
PS1+="${GRAY}\w" # Working directory
PS1+="\$(prompt_git \"${GRAY} ${GRAY}\")" # git repository details
PS1+="\n" # Newline
PS1+="\[${RESET}\]\$ " # $ (and reset color)
