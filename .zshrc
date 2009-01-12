# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

if [ -n "$DISPLAY" ]
then
	xrdb -merge ~/.Xresources
fi

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename '/home/lukas/.zshrc'

autoload -Uz compinit promptinit
compinit
promptinit
# End of lines added by compinstall

# /usr/share/zsh/4.3.4/functions/Prompts/
prompt gentoo2

# keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char

case $TERM in (xterm*)
	bindkey '\e[H' beginning-of-line
	bindkey '\e[F' end-of-line ;;
esac

# env
export MANPAGER=vimmanpager
export EDITOR=vim
# ConTeXt
#export PATH=/home/lukas/apps/context/tex/texmf-linux/bin:$PATH
#export TEXMF=/home/lukas/apps/context/tex/texmf-linux
#export TEXMFCNF=/home/lukas/apps/context/tex/texmf-context/web2c
#export LUAINPUTS=/home/lukas/apps/context/tex/texmf-context/tex/context/base/:/home/lukas/apps/context/tex/texmf-context/scripts/context/lua
#export MANPATH=/home/lukas/apps/context/tex/texmf-linux/man:$MANPATH
#cd ~/apps/context/tex/ && . ./setuptex >/dev/null
# also run:
#~ luatools --generate && context --make

# aliases
alias ls="ls --color=auto"
alias ll="ls --color=auto -la"
alias grep="grep --colour=auto"
alias fgrep="fgrep --colour=auto"
alias man="LANG=C man"
alias ri="ri -Tf ansi"
alias s="screen"
alias irb="irb --readline -r irb/completion"
# aliases for X
if [ -n "$DISPLAY" ]
then
	alias mc="mc -x"
	alias feb="$HOME/feb > /dev/null 2>&1 &"
	alias febt="THUMBS=1 $HOME/feb > /dev/null 2>&1 &"
	alias smplayer="LANG=C smplayer"
	alias e="gvim"
else
	alias e="vim"
fi

cd ~

