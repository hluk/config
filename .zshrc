# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename '/home/lukas/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

# /usr/share/zsh/4.3.4/functions/Prompts/
prompt zefram
export PS1='%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~%(?..%F{red}[%v]%f)%(!.#.>)%b '

# keys
bindkey '[1~' beginning-of-line
bindkey '[4~' end-of-line
bindkey '[3~' delete-char

# env
export CHOST="i686-pc-linux-gnu"
export CFLAGS="-pipe -O2 -march=pentium4 -msse2 -mfpmath=sse -fomit-frame-pointer"
export CXXFLAGS="${CFLAGS}"
export MAKEOPTS="-j2"
# ccache
export PATH="/usr/lib/ccache/bin/:$PATH"
export CCACHE_DIR="$HOME/.ccache"
export CCACHE_SIZE="4G"
export SANDBOX_WRITE="${SANDBOX_WRITE}:${CCACHE_DIR}"

export MANPAGER=vimmanpager
export EDITOR=vim

# ConTeXt
#export PATH=/home/lukas/apps/context/tex/texmf-linux/bin:$PATH
#export TEXMF=/home/lukas/apps/context/tex/texmf-linux
#export TEXMFCNF=/home/lukas/apps/context/tex/texmf-context/web2c
#export LUAINPUTS=/home/lukas/apps/context/tex/texmf-context/tex/context/base/:/home/lukas/apps/context/tex/texmf-context/scripts/context/lua
#export MANPATH=/home/lukas/apps/context/tex/texmf-linux/man:$MANPATH
#(cd ~/apps/context/tex/ && . ./setuptex >/dev/null)
# it may also help to run:
#~ luatools --generate && context --make

# aliases
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

# X server running?
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
fi

#cd ~

