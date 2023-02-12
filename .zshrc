# ALT-H is command help
# edit command line on C-x C-e

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# env# {{{
export EDITOR="$HOME/dev/bin/editor.sh"
export PAGER=less
export LESS="--ignore-case --quit-if-one-screen --LONG-PROMPT --shift=5"

# support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;33m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/dev/Nim/bin:$PATH"
export PATH="$HOME/dev/bin:$PATH"
export PATH="$HOME/dev/scripts:$PATH"

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
# }}}

# basic configuration# {{{
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
bindkey -e

# keys
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[P' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word

# tmux
bindkey -v '^[OH' beginning-of-line
bindkey -v '^[OF' end-of-line

# kitty terminal
bindkey -v '\e[H'  beginning-of-line
bindkey -v '\e[F'  end-of-line
bindkey -v '\e[3~' delete-char

autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line

# no CTRL-S
setopt NO_FLOW_CONTROL
# }}}

# completion# {{{
autoload -Uz compinit
compinit

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename "$HOME/.zshrc"

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
zstyle ':completion::*:(rm|cp|mv|e):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false
# }}}

# aliases {{{
alias rm="rm -vI"
alias cp="cp -v"
alias mv="mv -v"
alias ls="ls --color=auto -h"
alias ll="ls -lA"
alias l="ls -lAtr"
alias grep="grep --colour=auto"
alias man="LESS='' LANG=C man"
alias ssh="env TERM=xterm ssh"
alias unpack="~/dev/bin/unpack.sh"
alias natsort=~/dev/natsort/natsort
alias m="QT_SCREEN_SCALE_FACTORS=1 smplayer"
alias venv='python3 -m venv .venv && source .venv/bin/activate && pip install --upgrade pip setuptools -q'
alias copyq="$HOME/dev/build/copyq/release/copyq"
alias :q="exit"

alias open="xdg-open"

alias g="git"
alias gc="git co"
alias gd="git d"
alias gf="git f"
alias gs="git show"
alias gst="git st"
alias gu="git up"
alias gg="lazygit"
alias gpr="git pr"

gl() {
    git la --color -$LINES | head -$((LINES - 4))
}

gup() {
    if git branch --list main|grep -q .; then
        branch=main
    elif git branch --list develop|grep -q .; then
        branch=develop
    else
        branch=master
    fi
    git checkout $branch &&
        git pull --rebase upstream $branch &&
        git push origin $branch
}

if [ -n "$DISPLAY" ]; then
    alias mc="mc -x"
else
    alias xx="startx"
fi

# package manager
. /etc/os-release
if [[ $NAME =~ "Fedora" ]]; then
    alias q="dnf"
    alias s="q search --cacheonly --all"
    alias i="sudo dnf install"
    alias u="sudo dnf remove"
    alias up="sudo dnf upgrade"
elif [[ $NAME =~ "Arch Linux" ]]; then
    #alias q="pacaur"
    #alias q="trizen"
    alias q="yay"
    alias s="q -Ss"
    alias i="q -S"
    alias u="sudo pacman -Rs"
    alias up="q -Syu --devel --needed"
    alias Up="q -Qe|awk -F'[/ ]' '/^local/{if(\$2~/-(git|svn|bzr|hg|nightly)$/)print\$2}'"
    alias qdiff="sudo pacdiff"
    #alias up="q -Syu --aur"
    alias clean="q -Qdt"
elif [[ $NAME =~ "Ubuntu" ]]; then
    alias q="apt"
    alias s="q search"
    alias i="sudo apt install"
    alias u="sudo apt remove"
    alias up="sudo apt update && sudo apt upgrade"
fi

alias b0="~/dev/scripts/bluetooth.sh off"
alias b1="~/dev/scripts/bluetooth.sh on"
alias w0="~/dev/scripts/work.sh off"
alias w1="~/dev/scripts/work.sh on"

# cd ~d
d=~/Downloads
b=~/dev/bin
f=~/dev/factory
# }}}

# functions {{{
# open editor in tmux in new window
e() {
    label=">$1${2:+..}"
    if [[ -n $TMUX ]]; then
      tmux new-window $EDITOR "$@"
    else
      $EDITOR "$@"
    fi
}
# }}}

# {{{ fd, fzf, rg
# A-c: cd
# C-t: complete path
# C-r: history
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
if [ -d ~/.fzf ]; then
    export PATH="$HOME/.fzf/bin:$PATH"
    export FZF_DEFAULT_COMMAND='rg --files'
    #export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--history=$HOME/.local/share/fzf_history"
    export FZF_ALT_C_COMMAND='fd --type directory'

    source ~/.fzf.zsh
    source "$HOME/.fzf/shell/completion.zsh"
    source "$HOME/.fzf/shell/key-bindings.zsh"
fi
# }}}

# plugins {{{
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888899,bg=0"
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/romkatv/powerlevel10k
source ~/dev/powerlevel10k/powerlevel10k.zsh-theme
# }}}

# ccache {{{
PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G >/dev/null
# }}}

# Use vi mode
bindkey -v
bindkey -M vicmd v edit-command-line
bindkey -v '^?' backward-delete-char
export KEYTIMEOUT=1

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.config/broot/launcher/bash/br
