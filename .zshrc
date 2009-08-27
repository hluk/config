# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
bindkey -e

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename '/home/lukas/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit

# prompts: /usr/share/zsh/4.3.4/functions/Prompts/
prompt zefram
export PS1='%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~%(?..%F{red}[%v]%f)%(!.#.>)%b '

# keys
bindkey '[1~' beginning-of-line
bindkey '[4~' end-of-line
bindkey '[3~' delete-char

# env# {{{
# - proxy
export http_proxy=localhost:8118
# - build
export CHOST="i686-pc-linux-gnu"
export CFLAGS="-pipe -O3 -march=pentium4 -msse2 -mfpmath=sse -fomit-frame-pointer"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j2"
# - ccache
export PATH="/usr/lib/ccache/bin/:$PATH"
export CCACHE_DIR="$HOME/.ccache"
export CCACHE_SIZE="4G"
export SANDBOX_WRITE="${SANDBOX_WRITE}:${CCACHE_DIR}"

export MANPAGER=vimmanpager
export EDITOR=vim

export XDG_DATA_HOME="$HOME/.config"
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

# aliases# {{{
alias ls="ls --color=auto"
alias ll="ls --color=auto -lA"
alias grep="grep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias man="LANG=C man"
alias ri="ri -Tf ansi"
alias s="screen"
alias irb="irb --readline -r irb/completion"
alias x="startx > .xsession 2>&1 &"
alias lpr="lpr -o InputSlot=Default -o Resolution=600x600dpi -o PageSize=A4"
alias rcdiff="vimdiff {~/.config,/etc/xdg}/awesome/rc.lua"
alias q="paludis -q"

# - X aliases
if [ -n "$DISPLAY" ]
then
	#xrdb -merge ~/.Xresources

	export TERM=xterm-color 
	export TERMINFO=$HOME/lib/terminfo

	case $TERM in (xterm*)
		bindkey '\e[H' beginning-of-line
		bindkey '\e[F' end-of-line ;;
	esac

	# aliases for X
	alias mc="mc -x"
	alias feb="$HOME/feb"
	alias febt="THUMBS=1 $HOME/feb"
	alias smplayer="LANG=C smplayer"
	#export EDITOR="$HOME/svim.sh"
	export EDITOR="gvim"
	alias e="$EDITOR"
	alias v="$HOME/apps/comix/src/comix.py"
	alias xnview="wine ~/.wine/drive_c/Program\ Files/XnView/xnview.exe"
	alias chromium="$HOME/chromium.sh"
	alias fontmatrix="$HOME/apps/fontmatrix/build/src/fontmatrix"
fi

# edit privoxy user settings
alias adblock="su -c \"$EDITOR -c ':cd /etc/privoxy' -c ':e user.action'\""
# }}}

# func: unpack file [dir] # {{{
# info: Unpack file in dir.
unpack() {
	if [ -f "$1" ]
	then
		case "$1" in
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
			echo "File '$1' cannot be extracted!"
			return 1
			;;
		esac

		# filename with full path
		FILE=`readlink -f "$1"`

		(
		# create dir
		if [ -n "$2" ]
		then
			mkdir -p "$2" && cd "$2" || exit 1
		fi

		# unpack
		eval "$CMD \"$FILE\""
		) || return 1
	else
		echo "'$1' is not a valid file"
		return 1
	fi
	return 0
} # }}}

