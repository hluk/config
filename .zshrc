# basic configuration# {{{
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
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
export EDITOR="vim"
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
alias ls="ls --color=auto"
alias ll="ls --color=auto -lA"
alias grep="grep --colour=auto"
alias fgrep="fgrep --colour=auto"
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

alias ifconfig="echo \"Use 'ip addr' command.\""
alias netstat="echo \"Use 'ss' command.\""

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
	#alias e="gvim"
    alias mc="mc -x"
    alias m="ranger"
	alias feb="$HOME/dev/bin/feb"
	alias febt="THUMBS=1 $HOME/dev/bin/feb"
	alias smplayer="LANG=C smplayer"
	alias v="$HOME/dev/gallery/mkgallery.py -u http://localhost:8080/Galleries/%s/"
	alias traycmd="$HOME/dev/bin/traycmd.py"
	alias grooveshark="$HOME/dev/grooveshark/grooveshark_toggle.sh show & traycmd $HOME/dev/grooveshark/{grooveshark.png,grooveshark_toggle.sh}"
    alias copyq="$HOME/dev/copyq-build/debug/copyq"
    alias wallpaper="$HOME/dev/img/set_wallpaper.sh"
    alias jdownloader="java -Xmx256m -jar $HOME/apps/JDownloader/JDownloader.jar"
    #alias wine32="WINEDEBUG=fixme-all LIBGL_DRIVERS_PATH=/opt/lib32/usr/lib/xorg/modules/dri wine"
    #alias q4wine="LIBGL_DRIVERS_PATH=/opt/lib32/usr/lib/xorg/modules/dri q4wine"
    #alias blender="LIBGL_ALWAYS_SOFTWARE=1 blender"
else
	alias x="startx > $HOME/.xsession 2>&1 &"
fi
# }}}

alias Gitd="git diff --color"
alias Gitc="git commit --interactive -m"
alias Gits="git show --color"
alias Gitp="git push origin master"

# yaourt
export PACMAN=pacman-color
alias q="yaourt"
alias i="yaourt -S"
alias u="yaourt -Rs"
alias qdiff="yaourt -C"
alias up="yaourt -Syu --aur"
alias clean="yaourt -Qdt"

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

e () {
    screen -t ">$@" "$EDITOR" $@
}

# func: flash url/command# {{{
# play flash videos
flash() {
    (
    CMD=~/apps/get-flash-videos/get_flash_videos
    mkdir -p ~/down/_flash &&
    cd ~/down/_flash/ || return 1
    case "$1" in
        "clean")
            rm *.(mp4|flv|mov|avi) ;;
        "update")
            git pull ;;
        "")
            "$CMD" --play `xclip -o`;;
        *)
            "$CMD" --play $@ ;;
    esac
    )
}
# }}}

# autojump needs this
source /etc/profile

# pulseaudio
#pidof pulseaudio >/dev/null || pulseaudio --start || echo "ERROR: Cannot start Pulseaudio!"

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

# func: v_archive file ... {{{
# view archive contents (images, videos, fonts)
# use G variable to set gallery name
v_archive() {
    DIR=~/.archives/${G:-default}

    FILES=""
    for archive in "$@"
    do
        DEST="$DIR/`basename "$archive"`"
        unpack "$archive" "$DEST" || return 1
        FILES="$FILES""$DEST\0"
    done
    [ -n "$FILES" ] || return 1

    printf "$FILES" | xargs -0 "$HOME/dev/gallery/mkgallery.py" \
        -u http://localhost:8080/Galleries/%s/ -t ${G:-default} -fp-1

    echo "Press any key to delete unpacked files."; read &&
        printf "$FILES" | xargs -0 rm -r && rmdir "$DIR"
}
# }}}

# cd ~d
d=~/down
v=~/dev
m=~/Movies
p=~/Pictures
w=~/wallpapers
g=~/dev/gallery

# syntax highlighting
source ~/apps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

