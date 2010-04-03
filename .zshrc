# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
bindkey -e

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit promptinit
compinit
promptinit

# prompts: /usr/share/zsh/4.3.4/functions/Prompts/
prompt zefram
export PS1='%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~%(?..%F{red}[%v]%f)%(!.#.>)%b '

# keys
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey '5D' backward-word
bindkey '5C' forward-word

# This makes cd=pushd
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# no CTRL-S
setopt NO_FLOW_CONTROL

# Case insensitive globbing
setopt NO_CASE_GLOB

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
zstyle ':completion::*:(rm|vi):*' ignore-line true

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
export CFLAGS="-march=core2 -O2 -pipe"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j7"
# - ccache
export PATH="/usr/lib/ccache/bin/:${PATH}"
export CCACHE_DIR="$HOME/.ccache"
export CCACHE_SIZE="4G"
export SANDBOX_WRITE="${SANDBOX_WRITE}:${CCACHE_DIR}"

# X11# {{{
if [ -n "$DISPLAY" ]
then
	export BROWSER="$HOME/chromium.sh"
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

# func: unpack file [dir] # {{{
# info: Unpack file in dir.
unpack() {
    lst=($@)

    # directory to unpack files
    d=.
    if [ $# -gt 1 ]
    then
        d=${@[$#]}
        lst=(${@[1,$((#-1))]})
        # create dir
        if ! mkdir -p "$d" 2> /dev/null
        then
            echo -e "usage:\n  $0 file [dir]\n  $0 file1 file2 ... dir"
            return 1
        fi
    fi

    for f in $lst
    do
        if [ -f "$f" ]
        then
            case "$f" in
                *.tar)     CMD="tar xvf"    ;;
                *.tbz2)    CMD="tar xvjf"   ;;
                *.tgz)     CMD="tar xvzf"   ;;
                *.tar.*)   CMD="tar xvf"    ;;
                *.bz2)     CMD="bunzip2"    ;;
                *.rar)     CMD="unrar x"    ;;
                *.gz)      CMD="gunzip"     ;;
                *.zip)     CMD="unzip"      ;;
                *.Z)       CMD="uncompress" ;;
                *.7z)      CMD="7z x"       ;;
                *)
                echo "File '$f' cannot be extracted!"
                return 1
                ;;
            esac

            # filename with full path
            FILE=`readlink -f "$f"`

            # unpack
            (
            echo "$CMD \"$FILE\""
            cd "$d" && eval "$CMD \"$FILE\"" || return 2
            )
        else
            echo "'$f' is not a valid file"
            return 3
        fi
    done
	return 0
} # }}}

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
        W=0

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

# aliases# {{{
alias e="vim"
alias ls="ls --color=auto"
alias ll="ls --color=auto -lA"
alias grep="grep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias man="LANG=C man"
alias s="screen"
alias irb="irb --readline -r irb/completion"
alias lpr="lpr -o InputSlot=Default -o Resolution=600x600dpi -o PageSize=A4"
alias rcdiff="vimdiff {~/.config,/etc/xdg}/awesome/rc.lua"
alias dict="~/dev/translate/translate.py"
alias p="echo -n 'Press any key to continue...'; read -sn 1; echo"
alias unpackall="for x in *.(zip|rar); do unpack \$x \${x%.???}; done"

alias q="yaourt"
alias i="yaourt -S"
alias u="yaourt -Rs"
alias up="yaourt -Syu --aur"
alias clean="yaourt -Qdt"

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
	alias mc="mc -x"
	alias feb="$HOME/feb"
	alias febt="THUMBS=1 $HOME/feb"
	alias smplayer="LANG=C smplayer"
	#alias v="$HOME/apps/comix/src/comix.py"
	alias v="$HOME/dev/gallery/mkgallery.sh"
	alias chromium="$HOME/chromium.sh"
	alias e="gvim"
    alias copyq="$HOME/dev/qt/copyq/release/copyq"

	# wine apps
	alias xnview="wine ~/.wine/drive_c/Program\ Files/XnView/xnview.exe"
	alias foobar="wine ~/.wine/drive_c/Program\ Files/foobar2000/foobar2000.exe"
else
	alias x="startx > $HOME/.xsession 2>&1 &"
fi
# }}}

# edit privoxy user settings
alias adblock="su -c \"$EDITOR -c ':cd /etc/privoxy' -c ':e user.action'\""
# }}}

# func: dt program# {{{
# info: Detach program from console and exit.
d() {
	$@ & disown && exit
} # }}}

notes

