# basic configuration# {{{
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit promptinit
compinit
promptinit

#export REPORTTIME=1

# prompts: /usr/share/zsh/4.3.4/functions/Prompts/
prompt zefram
git_branch()
{
    git branch 2> /dev/null | sed -n -e 's/^* (no branch)/%F{red}(*)%f/p' -e 's/^* \(.*\)/%F{cyan}(\1)%f/p'
}
export PS1='%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~$(git_branch)%(?..%F{red}[%v]%f)%(!.#.>)%b '

# keys
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word
# ALT-H is command help

# edit command line on C-x C-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line

# vi mode
#bindkey -v

#setopt menucomplete

# This makes cd=pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# no CTRL-S
setopt NO_FLOW_CONTROL

# Case insensitive globbing
#setopt NO_CASE_GLOB

# extended globbing - e.g. (all files except *.txt): ^*.txt
#setopt extendedglob
# }}}

# completion# {{{
# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _approximate _ignored

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

## Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

## Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

## Have the newer files last so I see them first
#zstyle ':completion:*' file-sort modification reverse

#unsetopt LIST_AMBIGUOUS
setopt  COMPLETE_IN_WORD

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|cp|mv|gvim|mplayer):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false
# }}}

# env# {{{
export XDG_DATA_HOME="$HOME/.config"
export EDITOR="vim"
#export PAGER=most

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# X11# {{{
if [ -n "$DISPLAY" ]
then
    export BROWSER=~/dev/bin/browser.sh
fi
# }}}
# }}}

# aliases {{{
alias rm="rm -vI"
alias cp="cp -v"
alias mv="mv -v"
alias ls="ls --color=auto -h"
alias ll="ls -lA"
alias l="ls -lAtr"
alias grep="grep --colour=auto"
alias man="LANG=C man"
alias s="screen"
alias unpack="~/dev/bin/unpack.sh"
alias flash=~/dev/bin/flash.sh
alias fl='export F=`ls -t /tmp/Flash*|head -1`;m $F'
alias natsort=~/dev/natsort/natsort
#alias m="mplayer -quiet"
alias m="smplayer"
alias m0="mplayer -vo null -vc null -novideo"
alias binwalk="~/apps/binwalk/src/binwalk -m ~/apps/binwalk/src/magic.binwalk"
alias mkgallery='PATH="/home/lukas/dev/imagepeek:$PATH" ~/dev/bin/mkgallery.sh'

alias ifconfig="echo \"Use 'ip addr' command.\""
alias netstat="echo \"Use 'ss' command.\""

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
    alias mc="mc -x"
	alias feb="$HOME/dev/bin/feb.sh"
	alias febt="THUMBS=1 $HOME/dev/bin/feb.hs"
    alias copyq="$HOME/dev/copyq/build/copyq"
    alias copyq-debug="$HOME/dev/copyq-build/debug/copyq"

    export IMAGEPEEK_SESSION="$HOME/.imagepeek"
    alias peek="$HOME/dev/imagepeek/imagepeek"
    alias peeks="PATH=\"$HOME/dev/imagepeek:$PATH\" peeks"
    alias quick="~/dev/imagequick-build-desktop-Qt_in_PATH_Release/imagequick"
    alias qtcreator="~/apps/qt-creator/build/bin/qtcreator -lastsession"
else
	alias x="startx > $HOME/.xsession 2>&1 &"
fi
# }}}

# yaourt
export PACMAN=pacman-color
alias q="yaourt"
alias i="q -S"
alias u="q -Rs"
alias qdiff="q -C"
alias up="q -Syu --aur"
alias Up="q -Qe|awk -F'[/ ]' '/^local/{if(\$2~/-(git|svn|bzr|hg|nightly)$/)print\$2}'"
alias clean="q -Qdt"

# volume and brightness
alias volup="~/dev/bin/volume.sh 8%+"
alias voldown="~/dev/bin/volume.sh 8%-"
alias brightup="~/dev/colors/backlight.sh 8"
alias brightdown="~/dev/colors/backlight.sh -8"

alias poweroff="sudo poweroff"
alias reboot="sudo reboot"

# cd ~d
d=~/down
v=~/dev
m=~/Movies
p=~/Pictures
w=~/wallpapers
g=~/dev/gallery
f=~/down/_flash
t=~/down/_torrents
c=~/dev/copyq
i=~/dev/imagepeek
# }}}

# functions {{{
# simple find
f ()
{
    name=$1
    shift
    find "$@" -iname "*$name*"
}

# open editor in GNU screen in new window
e ()
{
    screen -t ">$*" vim "$@"
}

S ()
{
    (
    cd "$1"
    screen -t "#${1:-`basename "$PWD"`}" vim -S Session.vim
    )
}

# play flash movies
pflv()
{
    pid=$(pgrep -f flashplayer | tail -l)
    file=$(lsof -p ${pid} | awk \
        '/\/tmp\/Flash/ {sub(/[rwu]$/, "", $4); print "/proc/" $2 "/fd/" $4}')
    echo "$file"
    vlc ${file}
}

# make directory if it does not exist and cd to it
mkcd()
{
    mkdir -p "$*" && cd "$*"
}
# }}}

# plugins {{{
# productivity
source ~/apps/z/z.sh
function precmd () {
    _z --add "$(pwd -P)"
}
alias v='~/apps/v/v'

# syntax highlighting
source ~/apps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets )
ZSH_HIGHLIGHT_STYLES+=(
    alias                   'fg=magenta,bold'
    path                    'fg=cyan'
    globbing                'fg=yellow'
    single-hyphen-option    'bold'
    double-hyphen-option    'bold'
)
ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'
# }}}

# ccache {{{
PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G >/dev/null
# }}}

export QBS_SOURCE_DIR=$HOME/apps/qbs
export QBS_BUILD_DIR=$QBS_SOURCE_DIR/build
export PATH=$QBS_SOURCE_DIR/build/bin:$PATH
#qbs config --global modules.qt.core.binPath /usr/bin
#qbs config --global modules.qt.core.incPath /usr/include
#qbs config --global modules.qt.core.libPath /usr/lib
#qbs config --global modules.qt.core.mkspecsPath /usr/share/qt/mkspecs
#qbs config --global modules.qt.core.version 5.0.0

