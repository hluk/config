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

# This makes cd=pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# no CTRL-S
setopt NO_FLOW_CONTROL

# Case insensitive globbing
#setopt NO_CASE_GLOB
# }}}

# vi mode# {{{
#bindkey -v
#zle-keymap-select () {
  #if [ $TERM = "rxvt-256color" ]; then
    #if [ $KEYMAP = vicmd ]; then
      #echo -ne "\033]12;#ff6565\007"
    #else
      #echo -ne "\033]12;grey\007"
    #fi
  #elif [ $TERM = "screen" ]; then
    #if [ $KEYMAP = vicmd ]; then
      #echo -ne '\033P\033]12;#ff6565\007\033\\'
    #else
      #echo -ne '\033P\033]12;grey\007\033\\'
    #fi
  #fi
#}; zle -N zle-keymap-select
#zle-line-init () {
  #zle -K viins
  #if [ $TERM = "rxvt-256color" ]; then
    #echo -ne "\033]12;grey\007"
  #elif [ $TERM = "screen" ]; then
    #echo -ne '\033P\033]12;grey\007\033\\'
  #fi
#}; zle -N zle-line-init
#bindkey '^R' history-incremental-search-backward
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

# directories# {{{
export lapps=~/apps
export lbooks=~/eBooks
export ldev=~/dev
export ldown=~/down
export lmisc=~/Misc
export lmovies=~/Movies
export lpic=~/Pictures
export lschool=~/School
export lwallpapers=~/wallpapers
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
    export BROWSER="/usr/bin/chromium-browser"
    #export BROWSER="/usr/bin/google-chrome"
	#export BROWSER="firefox"
	#export TERM=xterm-color 
	#export TERMINFO=$HOME/lib/terminfo

	case $TERM in (xterm*)
		bindkey '\e[H' beginning-of-line
		bindkey '\e[F' end-of-line ;;
	esac
fi
# }}}

# }}}

# ConTeXt # {{{
#export PATH=/home/lukas/apps/context/tex/texmf-linux/bin:$PATH
#export TEXMF=/home/lukas/apps/context/tex/texmf-linux
#export TEXMFCNF=/home/lukas/apps/context/tex/texmf-context/web2c
#export LUAINPUTS=/home/lukas/apps/context/tex/texmf-context/tex/context/base/:/home/lukas/apps/context/tex/texmf-context/scripts/context/lua
#export MANPATH=/home/lukas/apps/context/tex/texmf-linux/man:$MANPATH
#(cd ~/apps/context/tex/ && . ./setuptex >/dev/null)
# it may also help to run:
#~ luatools --generate && context --make # }}}

# func: notes # {{{
# info: Print notes from ~/notes directory.
notes() {
    # colors
    C_H1="\033[0;33m"
    C_END="\033[0m"
    C_ENDX="\\\033[0m"
    C_ITEM="\\\033[0;36m-$C_ENDX"
    C_TODO="\\\033[0;31m[ ]$C_ENDX"
    C_DONE="\\\033[0;30m[\\\033[0;32mX$C_ENDX\\\033[0;30m]$C_ENDX"
    C_H2="\\\033[0;36m\2$C_ENDX"
    # vertical line
    D_V="│"
    D_VX="\\$C_H1│\\$C_END"

	(
	cd ~/notes || return
    
	for f in *
	do
        TXT=""
        W=$#f

        # get max width
        cat "$f" |
        while L=`line`
        do
            if [ $#L -gt $W ]
            then
                W=$#L
            fi
        done
        W=$((W+2))

        # horizontal line
        D_L=`repeat $W; do printf "─"; done`

        # print header
        echo -e "${C_H1}┌$D_L┐$C_END"
		printf  "${C_H1}$D_V%${W}s$D_V$C_END\n" "$f "

        # print content
        cat "$f" |
        while L=`line`
        do
            S="`printf "%$((W-1-$#L))s" " "`"
            echo -e "`sed \
                -e 's/^\(\s*\)-/\1'"$C_ITEM"'/' \
                -e 's/^\(\s*\)\[ \]/\1'"$C_TODO"'/' \
                -e 's/^\(\s*\)\[X\]/\1'"$C_DONE"'/' \
                -e 's/^\(\s*\)\([A-Z].*\)/\1'"$C_H2"'/' \
                -e 's/^/'"$D_VX"' /' \
                -e 's/$/'"$S$D_VX"'/' \
                <<< "$L"`"
        done
        
        echo -e "${C_H1}└$D_L┘$C_END"
	done
	) 2> /dev/null
    return
}
# }}}

# func: check # {{{
# info: (Un)checks task.
# args: task numbers
#       none or 0 to check next unchecked
check() {
	(
	cd ~/notes || return 1

    if [ $# -eq 0 ]
    then
        check 0
        return $?
    fi

    for n in $@
    do
        if [ $n -eq 0 ]
        then
            X=`grep -m 1 -Hne '^\s*\[ \]' *`
        else
            X=`grep -Hne '^\s*\[.\]' *|sed -n "${n}p"`
        fi
        test -n "$X" || return 1

        file="`awk -F: '{print $1}' <<< "$X"`"
        ln="`awk -F: '{print $2}' <<< "$X"`"
        str="`awk -F: '{print $3}' <<< "$X"`"
        
        t="X"
        if grep -qe '^\s*\[X\]' <<< "$str"
        then
            t=" "
        fi

        sed -i "$ln"'{s/^\(\s*\)\[.\]/\1\['"$t"'\]/}' "$file"
    done

    notes
    )
}
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
alias e="vim"
alias S="e -S Session.vim"
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

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
	alias e="gvim"
    alias mc="mc -x"
    alias m="ranger"
	alias feb="$HOME/dev/bin/feb"
	alias febt="THUMBS=1 $HOME/dev/bin/feb"
	alias smplayer="LANG=C smplayer"
	alias v="$HOME/dev/gallery/mkgallery.py"
	alias traycmd="$HOME/dev/bin/traycmd.py"
	alias grooveshark="$HOME/dev/grooveshark/grooveshark_toggle.sh show & traycmd $HOME/dev/grooveshark/{grooveshark.png,grooveshark_toggle.sh}"
    alias copyq="$HOME/dev/copyq-build/release/copyq"
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
alias q="yaourt"
alias i="yaourt -S"
alias u="yaourt -Rs"
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

# func: dt program# {{{
# info: Detach program from console and exit.
d() {
	$@ & disown && exit
} # }}}

# func: flash url/command# {{{
# play flash videos
flash() {
    (
    cd ~/apps/get-flash-videos || return 1
    case "$1" in
        "clean")
            rm *.(mp4|flv|mov|avi) ;;
        "update")
            git pull ;;
        "")
            ./get_flash_videos --play "`xclip -o`";;
        *)
            ./get_flash_videos --play $@ ;;
    esac
    mkdir -p ~/down/_flash
    mv *.(mp4|flv|mov|avi) ~/down/_flash
    )
}
# }}}

notes

# autojump
#source /etc/profile.d/autojump.zsh

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

# cd ~d
d=~/down
v=~/dev
m=~/Movies
p=~/Pictures
w=~/wallpapers
g=~/dev/gallery

