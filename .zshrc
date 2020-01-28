# env# {{{
export EDITOR="nvim"
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
# }}}

# basic configuration# {{{
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_expire_dups_first
bindkey -e

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit promptinit
compinit
promptinit

setopt prompt_subst

ps_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^* (no branch)/%F{red}(*)%f/p' -e 's/^* \(.*\)/%F{magenta}(\1)%f/p'
}

ps_path() {
    printf '%s' '%F{blue}%~%f'
}

ps_error_code() {
    printf '%s' '%(?..%F{red}[%?]%f)'
}

ps_prompt() {
    printf '%s' '%F{blue}%(!.#.>)%f'
}

ps1() {
    #export PS1='%B$(ps_path)$(ps_git_branch)$(ps_error_code)$(ps_prompt)%b '

    # cargo install starship
    # https://starship.rs/config/#prompt
    eval "$(starship init zsh)"
}

ps1

# keys
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[P' delete-char
bindkey '^[[Z' reverse-menu-complete
bindkey "^[OD" backward-word
bindkey "^[OC" forward-word
# ALT-H is command help

# edit command line on C-x C-e
autoload edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line
bindkey '^X^e' edit-command-line

# no CTRL-S
setopt NO_FLOW_CONTROL
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

# aliases {{{
alias rm="rm -vI"
alias cp="cp -v"
alias mv="mv -v"
alias ls="ls --color=auto -h"
alias ll="ls -lA"
alias l="ls -lAtr"
alias grep="grep --colour=auto"
alias man="LESS='' LANG=C man"
alias unpack="~/dev/bin/unpack.sh"
alias flash=~/dev/bin/flash.sh
alias fl='export F=`ls -t /tmp/Flash*|head -1`;m $F'
alias natsort=~/dev/natsort/natsort
#alias m="mplayer -quiet"
alias m="QT_SCREEN_SCALE_FACTORS=1 smplayer"
alias m0="mplayer -vo null -vc null -novideo"
alias binwalk="~/apps/binwalk/src/binwalk -m ~/apps/binwalk/src/magic.binwalk"
alias mkgallery='PATH="/home/lukas/dev/imagepeek:$PATH" ~/dev/bin/mkgallery.sh'

# helgrind: detect race conditions
#alias helgrind="QT_NO_GLIB=1 valgrind --tool=helgrind --track-lockorders=no"
alias helgrind="QT_NO_GLIB=1 valgrind --tool=helgrind"

alias wine32="WINEARCH=win32 WINEPREFIX=$HOME/.wine32 wine"
alias winetricks32="WINEARCH=win32 WINEPREFIX=$HOME/.wine32 winetricks"

# X11# {{{
if [ -n "$DISPLAY" ]
then
	# aliases for X
    alias mc="mc -x"
	alias feb="$HOME/dev/bin/feb.sh"
	alias febt="THUMBS=1 $HOME/dev/bin/feb.hs"
    alias copyq="$HOME/dev/build/copyq/release/copyq"

    export IMAGEPEEK_SESSION="$HOME/.imagepeek"
    alias peek="$HOME/dev/imagepeek/imagepeek"
    alias peeks="PATH=\"$HOME/dev/imagepeek:$PATH\" peeks"
    alias quick="~/dev/bin/imagequick.sh"
else
    alias xx="startx"
fi
# }}}

# package manager
. /etc/os-release
if [[ $NAME == "Arch Linux" ]]; then
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
elif [[ $NAME == "Fedora" ]]; then
    alias q="dnf"
    alias s="q search --cacheonly --all"
    alias i="sudo dnf install"
    alias u="sudo dnf remove"
    alias up="sudo dnf upgrade"
elif [[ $NAME == "Ubuntu" ]]; then
    alias q="apt"
    alias s="q search"
    alias i="sudo apt install"
    alias u="sudo apt remove"
    alias up="sudo apt update && sudo apt upgrade"
fi

# cd ~d
d=~/down
b=~/dev/bin
f=~/dev/factory
# }}}

# functions {{{
# open editor in GNU screen in new window
e() {
    #screen -t ">$*" $EDITOR "$@"
    tmux new-window -n ">$*" "$EDITOR \"$*\""
}

S() {
    (
    cd "$1"
    screen -t "#${1:-`basename "$PWD"`}" $EDITOR -S Session.vim
    )
}

# play flash movies
pflv() {
    pid=$(pgrep -f flashplayer | tail -l)
    file=$(lsof -p ${pid} | awk \
        '/\/tmp\/Flash/ {sub(/[rwu]$/, "", $4); print "/proc/" $2 "/fd/" $4}')
    echo "$file"
    smplayer ${file}
}

# make directory if it does not exist and cd to it
mkcd() {
    mkdir -p "$*" && cd "$*"
}

# "top" for processes with given names
topp() {
    htop -p $(pidof "$@" | tr ' ' ,)
}

backup() {
    file=$1
    date=$(date --iso-8601)
    7z a -p "$file-$date".7z "$file"
}

lyrics() {
    (
        source ~/dev/python-metallum/.venv/bin/activate &&
            ~/dev/bin/lyrics.py "$@"
    )
}

gup() {
    (
        set -e

        echo ' * fetching all'
        git fetch --all --tags

        branches="$(git branch --list --format '%(refname:short)' master devel develop)"
        for branch in $branches; do
            echo " * updading $branch"
            git checkout "$branch"
            git rebase "upstream/$branch"
            git push origin "$branch"
        done
    )
}
# }}}

# {{{ fd, fzf, rg
# A-c: cd
# C-t: complete path
# C-r: history
if [ -d ~/.fzf ]; then
    export PATH="$HOME/.fzf/bin:$PATH"
    export FZF_DEFAULT_COMMAND='rg --files'
    #export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--history=$HOME/.local/share/fzf_history"

    source ~/.fzf.zsh
    source "$HOME/.fzf/shell/completion.zsh"
    source "$HOME/.fzf/shell/key-bindings.zsh"

    bindkey '^K' fzf-file-widget
fi
alias rg="rg --max-columns 999"
# }}}

# plugins {{{
# syntax highlighting
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
# }}}

# ccache {{{
PATH=/usr/lib/ccache/bin:$PATH
ccache --max-size=8G >/dev/null
# }}}

# brew {{{
brew_init() {
    export BREW_PREFIX="$HOME/.linuxbrew"
    export PATH="$BREW_PREFIX/sbin:$BREW_PREFIX/bin:/usr/bin"
    export MANPATH="$(brew --prefix)/share/man:$MANPATH"
    export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
    export HOMEBREW_TEMP="$BREW_PREFIX/tmp"
    export PS1='%B%F{yellow}[brew]%B%F{blue}%n%(2v.%B@%b.@)%f%(!.%F{red}.%F{green})%m%f:%~$(git_branch)%(?..%F{red}[%?]%f)%(!.#.>)%b '
}
# }}}
