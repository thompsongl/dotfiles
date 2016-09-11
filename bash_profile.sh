#!/bin/bash

# bash_profile

declare -a files=(
    $HOME/.dotfiles/bash/bash_config # Configuration
    $HOME/.dotfiles/bash/bash_aliases # Aliases
    $HOME/.dotfiles/bash/functions/* # Functions
    $HOME/.dotfiles/bash/bash_prompt # Custom bash prompt
    $HOME/.dotfiles/bash/bash_paths # Path modifications (must source after `.bash_profile.local` in case of custom `brew` location)
)

# If these files are readable, source them
for index in ${!files[*]}
do
    if [[ -r ${files[$index]} ]]; then
        source ${files[$index]}
    fi
done

unset files

# Source Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Source Git Completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Source Bash Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

eval $(thefuck --alias fuck)
