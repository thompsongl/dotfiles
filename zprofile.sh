# load shared shell configuration
source ~/.shprofile

# Enable completions
autoload -U compinit && compinit

if which brew &>/dev/null
then
  [ -w "$HOMEBREW_PREFIX/bin/brew" ] && \
    [ ! -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew" ] && \
    mkdir -p "$HOMEBREW_PREFIX/share/zsh/site-functions" &>/dev/null && \
    ln -s "$HOMEBREW_PREFIX/Library/Contributions/brew_zsh_completion.zsh" \
          "$HOMEBREW_PREFIX/share/zsh/site-functions/_brew"
  FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fi

# Enable regex moving
autoload -U zmv

# Style ZSH output
zstyle ':completion:*:descriptions' format '%U%B%F{red}%d%f%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Case insensitive globbing
setopt no_case_glob

# Expand parameters, commands and aritmatic in prompts
setopt prompt_subst

# Colorful prompt with Git branch and status
autoload -U colors && colors

get_git_branch() {
    local branch_name
    branch_name=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
    branch_name=$(git rev-parse --short HEAD 2>/dev/null) ||
    branch_name='(unknown)'
    printf '%s' "$branch_name"
}

prompt_git() {
    local s=''
    local branchName=''

    if [ "$(git rev-parse --is-inside-work-tree &>/dev/null; printf '%s' $?)" = '0' ]; then
        if [ "$(git rev-parse --is-inside-git-dir 2>/dev/null)" = 'false' ]; then
            git update-index --really-refresh -q &>/dev/null

            if ! $(git diff --quiet --ignore-submodules --cached); then
                s="${s}+"
            fi
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s="${s}!"
            fi
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s="${s}?"
            fi
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s="${s}"'$'
            fi
        fi

        branchName="$(get_git_branch)"
        [ -n "$s" ] && s="[$s]"
        printf '%s' "$1($branchName)$s"
    fi
}

PROMPT='
%F{242}%n@%m: %~$(prompt_git " ")
%{$reset_color%}$ '
export RPROMPT=''

# more macOS/Bash-like word jumps
export WORDCHARS=""

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
