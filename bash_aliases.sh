#!/bin/bash

# bash_aliases

# Allow aliases to be with sudo
alias sudo="sudo "

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

# Git
alias g="git"
alias gs="git status"
alias gco="git checkout"
alias gl="git pull"
alias gpom="git pull origin master"
alias gp="git push"
alias gd="git diff | code -"
alias gb="git branch"
alias gba="git branch -a"
alias del="git branch -d"

# Reset previous commit, but keep all the associated changes.
alias goddammit="git reset --soft HEAD^"

# Welp.
alias heckit="git reset --hard HEAD"

# Even Steven
alias upstream="git checkout master && git fetch upstream &&  git merge upstream/master && git push origin HEAD && git checkout -"

# Open any files marked as “modified” in your default editor.
alias changed='open `git status --porcelain | sed -ne "s/^ M //p"`'

# List dir contents aliases
# ref: http://ss64.com/osx/ls.html
# Long form no user group, color
alias l="ls -oG"
# Order by last modified, long form no user group, color
alias lt="ls -toG"
# List all except . and ..., color, mark file types, long form no user group, file size
alias la="ls -AGFoh"
# List all except . and ..., color, mark file types, long form no use group, order by last modified, file size
alias lat="ls -AGFoth"

# Concatenate and print content of files (add line numbers)
alias catn="cat -n"

# Fancycat™
alias c="pygmentize -f console256 -g"

# “What was that alias again?” Meta!
alias aliases="c ~/.dotfiles/bash/bash_aliases"

# IP addresses
alias ip='IP=`dig +short myip.opendns.com @resolver1.opendns.com`; echo "${IP}"; echo "${IP}" | pbcopy'
alias lip='IP=`ipconfig getifaddr en0`; echo "${IP}"; echo "${IP}" | pbcopy'

# Copy my public key to the pasteboard
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | printf '=> Public key copied to pasteboard.\n'"

# Flush DNS cache
alias flushdns="dscacheutil -flushcache"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"

# Kill all Chrome windows/tabs
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Switch .npmrc files
alias npmprivate="rm ~/.npmrc && ln -s ~/.npmrc-privatenpm ~/.npmrc"
alias npmthompsongl="rm ~/.npmrc && ln -s ~/.npmrc-thompsongl ~/.npmrc"


# Create a data URI from a file and copy it to the pasteboard
datauri() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    printf "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')" | pbcopy | printf "=> data URI copied to pasteboard.\n"
}

# Thanks, Slexxy: https://gist.github.com/SlexAxton/4989674
gifify() {
  if [[ -n "$1" ]]; then
    if [[ $2 == '--good' ]]; then
      ffmpeg -i $1 -r 10 -vcodec png out-static-%05d.png
      time convert -verbose +dither -layers Optimize -resize 600x600\> out-static*.png  GIF:- | gifsicle --colors 128 --delay=5 --loop --optimize=3 --multifile - > $1.gif
      rm out-static*.png
    else
      ffmpeg -i $1 -s 600x400 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > $1.gif
    fi
  else
    echo 'Proper usage: `gifify <input_movie.mov>`. You DO need to include extension.'
  fi
}

# Compare original and gzipped file size
gz() {
    local origsize=$(wc -c < "$1")
    local gzipsize=$(gzip -c "$1" | wc -c)
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)

    printf "orig: %d bytes\n" "$origsize"
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# Start an HTTP server from a directory, optionally specifying the port
pyserver() {
    # Get port (if specified)
    local port="${1:-8000}"

    # Open in the browser
    open "http://localhost:${port}/"

    # Redefining the default content-type to text/plain instead of the default
    # application/octet-stream allows "unknown" files to be viewable in-browser
    # as text instead of being downloaded.
    #
    # Unfortunately, "python -m SimpleHTTPServer" doesn't allow you to redefine
    # the default content-type, but the SimpleHTTPServer module can be executed
    # manually with just a few lines of code.
    python -c $'import SimpleHTTPServer;\nSimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map[""] = "text/plain";\nSimpleHTTPServer.test();' "$port"
}

export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_11_HOME=$(/usr/libexec/java_home -v11)

alias java8='export JAVA_HOME=$JAVA_8_HOME'
alias java11='export JAVA_HOME=$JAVA_11_HOME'

# default to Java 11
java11
