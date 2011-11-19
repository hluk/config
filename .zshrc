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
export PS1='%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~%(?..%F{red}[%v]%f)%(!.#.>)%b '

# keys
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word
# ALT-H is command help

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
#export MANPAGER=vimmanpager
export EDITOR="vim -X"
# - proxy
#export http_proxy=localhost:8118
# - C flags
export CHOST="x86_64-pc-linux-gnu"
export CFLAGS="-march=native -pipe -O3 -flto -funroll-loops -fomit-frame-pointer"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j3"
# - ccache
export PATH="/usr/lib/ccache/bin/:${PATH}"
export CCACHE_DIR="$HOME/.ccache"
export CCACHE_SIZE="4G"
export SANDBOX_WRITE="${SANDBOX_WRITE}:${CCACHE_DIR}"

# X11# {{{
if [ -n "$DISPLAY" ]
then
    export BROWSER=~/dev/bin/browser.sh
	#export TERM=xterm-color 
	#export TERMINFO=$HOME/lib/terminfo

	case $TERM in (xterm*)
		bindkey '\e[H' beginning-of-line
		bindkey '\e[F' end-of-line ;;
	esac
fi
# }}}

# }}}

# func: Find # {{{
Find () {
    if [ $# -gt 1 ]
    then
        find $1 -iname "*$2*"
    else
        find -iname "*$1*"
    fi
}
# }}}

# aliases {{{
alias rm="rm -vI"
alias ls="ls --color=auto"
alias ll="ls --color=auto -lA"
alias grep="grep --mmap --colour=auto"
alias man="LANG=C man"
alias psx="ps auxf"
alias s="screen"
alias unpack="~/dev/bin/unpack.sh"
alias unpackall='for x in *; do unpack "$x" "x_$x" || ERROR="$ERROR\n$x"; done; echo "unpacking failed on:$ERROR"'
alias rcdiff="vimdiff {~/.config,/etc/xdg}/awesome/rc.lua"
alias dict="~/dev/translate/translate.py"
alias p="echo -n 'Press any key to continue...'; read -sn 1; echo"
alias equalizer="alsamixer -D equal"
alias S="e -S Session.vim"
alias flash=~/dev/bin/flash.sh
alias fl='export F=`ls -t /tmp/Flash*|head -1`;m $F'
alias natsort=~/dev/natsort/natsort
alias m="mplayer -quiet"
#alias m="LD_LIBRARY_PATH=~/apps/_root/lib mplayer -quiet"
alias mm="m -vo vaapi"
alias m0="m -vo null -vc null -novideo"
#alias m="smplayer"
#alias m="umplayer"
alias binwalk="~/apps/binwalk/src/binwalk -m ~/apps/binwalk/src/magic.binwalk"
alias v2="~/dev/bin/mkgallery.sh"

alias ifconfig="echo \"Use 'ip addr' command.\""
alias netstat="echo \"Use 'ss' command.\""

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
	#alias e="gvim"
    alias mc="mc -x"
	alias feb="$HOME/dev/bin/feb"
	alias febt="THUMBS=1 $HOME/dev/bin/feb"
	alias smplayer="LANG=C smplayer"
	alias v="$HOME/dev/gallery/mkgallery.py -u http://localhost:8080/Galleries/%s/"
	alias traycmd="$HOME/dev/bin/traycmd.py"
	alias grooveshark="$HOME/dev/grooveshark/grooveshark_toggle.sh show & traycmd $HOME/dev/grooveshark/{grooveshark.png,grooveshark_toggle.sh}"
    alias copyq="$HOME/dev/copyq-build/release/copyq"
    alias wallpaper="$HOME/dev/img/set_wallpaper.sh"
    alias jdownloader="java -Xmx256m -jar $HOME/apps/JDownloader/JDownloader.jar"
else
	alias x="startx > $HOME/.xsession 2>&1 &"
fi
# }}}

alias Gitd="git diff --color"
alias Gitc="git commit --interactive -m"
alias Gits="git show --color"
alias Gitp="git push origin master"
alias Gitl="git log --date-order --color --pretty=fuller --name-only"

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

# edit privoxy user settings
#alias adblock="su -c \"$EDITOR -c ':cd /etc/privoxy' -c ':e user.action'\""
# }}}

# open editor in GNU screen in new window
e () {
    screen -t ">$@" vim -X $@
}

# autojump
source /etc/profile.d/autojump.zsh

# func: pack [files]# {{{
# compress files
pack() {
    tar cvf - $@ | gzip -c > $1_`date +%Y%m%d`.tar.gz
}
# }}}

# func: yy [files]# {{{
# copy files recursively
yy() {
    COPY_FILES=()
    for x in $@
    do
        COPY_FILES=( ${COPY_FILES[@]} "$(readlink -f "$x")" )
    done
    export COPY_FILES
}
# }}}

# func: pp|pm|pl [directory]# {{{
# paste copied files recursively to given directory
pp() {
    test "$COPY_FILES" || return 1
    cp -rv $COPY_FILES "${1:-.}"
}
pm() {
    test "$COPY_FILES" || return 1
    mv -v $COPY_FILES "${1:-.}"
}
pl() {
    test "$COPY_FILES" || return 1
    ln -sv $COPY_FILES "${1:-.}"
}
# }}}

# cd ~d
d=~/down
v=~/dev
m=~/Movies
p=~/Pictures
w=~/wallpapers
g=~/dev/gallery
f=~/down/_flash

# syntax highlighting
source ~/apps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES+=(
    alias                   'fg=magenta,bold'
    path                    'fg=cyan'
    globbing                'fg=yellow'
    single-hyphen-option    'bold'
    double-hyphen-option    'bold'
)
# matching brackets
ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES=(
    'fg=blue,bold'    # Style for first level of imbrication
    'fg=green,bold'   # Style for second level of imbrication
    'fg=magenta,bold' # etc... Put as many styles as you wish, or leave
    'fg=yellow,bold'  # empty to disable brackets matching.
    'fg=cyan,bold'
)

