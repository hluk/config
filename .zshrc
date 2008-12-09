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
# tex
#export TEXMF=/usr/share/texmf-dist
#export TEXMFCNF=/usr/share/texmf/web2c
#export LUAINPUTS=/usr/share/texmf-dist/tex/context/base/:/usr/share/texmf-dist/scripts/context/lua
# ConTeXt
export PATH=/home/lukas/dev/context/tex/texmf-linux/bin:$PATH
export TEXMF=/home/lukas/dev/context/tex/texmf-linux
export TEXMFCNF=/home/lukas/dev/context/tex/texmf-context/web2c
export LUAINPUTS=/home/lukas/dev/context/tex/texmf-context/tex/context/base/:/home/lukas/dev/context/tex/texmf-context/scripts/context/lua
cd ~/dev/context/tex/ && . ./setuptex >/dev/null
# also run:
# luatools --generate && context --make

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
	alias smplayer="LANG=C smplayer"
fi

cd ~

