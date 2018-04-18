#!/bin/bash

# bash_profile

declare -a files=(
    $HOME/.bash_config # Configuration
    $HOME/.bash_aliases # Aliases
    $HOME/.bash_prompt # Custom bash prompt
    $HOME/.bash_paths # Path modifications (must source after `.bash_profile.local` in case of custom `brew` location)
)

# If these files are readable, source them
for index in ${!files[*]}
do
    if [[ -r ${files[$index]} ]]; then
        source ${files[$index]}
    fi
done

unset files

# Source Git Completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# # Source Bash Completion
# if [ -f $(HOMEBREW_PREFIX --prefix)/etc/bash_completion ]; then
#   . $(HOMEBREW_PREFIX --prefix)/etc/bash_completion
# fi


if [ hash thefuck 2>/dev/null ]; then
  eval $(thefuck --alias fuck)
fi

eval "$(nodenv init -)"
