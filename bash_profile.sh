#!/bin/bash

# bash_profile

declare -a files=(
    $HOME/.bash_config # Configuration
    $HOME/.bash_aliases # Aliases
    $HOME/.bash_prompt # Custom bash prompt
    $HOME/.bash_paths # Path modifications (must source after `.bash_profile.local` in case of custom `brew` location)
)
# # check if this is a login and/or interactive shell
# [ "$0" = "-bash" ] && export LOGIN_BASH=1
# echo "$-" | grep -q "i" && export INTERACTIVE_BASH=1

# # run bashrc if this is a login, interactive shell
# if [ -n "$LOGIN_BASH" ] && [ -n "$INTERACTIVE_BASH" ]
# then
#   source ~/.bashrc
# fi

# # Set HOST for ZSH compatibility
# export HOST="$HOSTNAME"

# # check the window size after each command and, if necessary,
# # update the values of LINES and COLUMNS.
# shopt -s checkwinsize

# If these files are readable, source them
for index in ${!files[*]}
do
    if [[ -r ${files[$index]} ]]; then
        source ${files[$index]}
    fi
done

unset files

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Git Completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Bash completion
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
if type brew &>/dev/null; then
  for COMPLETION in $(brew --prefix)/etc/bash_completion.d/*
  do
    [[ -f $COMPLETION ]] && source "$COMPLETION"
  done
  if [[ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]];
  then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi
fi

eval "$(nodenv init -)"
