# Shortcuts: https://fishshell.com/docs/current/#shared-bindings
# Alt-e ... edit command line in an editor
set PATH ~/go/bin $PATH
set PATH ~/.local/bin $PATH

export EDITOR="nvim"

alias rm="rm -vI"
alias cp="cp -v"
alias mv="mv -v"
alias ls="ls --color=auto -h"
alias ll="ls -lA"
alias grep="grep --colour=auto"
alias ssh="env TERM=xterm ssh"

# package manager
alias q="dnf"
alias s="q search --cacheonly --all"
alias i="sudo dnf install"
alias u="sudo dnf remove"
alias up="sudo dnf upgrade"

function e
    tmux new-window -n ">$argv" "$EDITOR \"$argv\""
end

function m
    export QT_SCREEN_SCALE_FACTORS=1
    smplayer $argv
end

function backup
    set file $argv[1]
    set date (date --iso-8601)
    7z a -p "$file-$date".7z "$file"
end

function tigl
    git log --pretty="commit %h %s" $argv | tig
end

set fish_greeting

starship init fish | source

source /usr/share/autojump/autojump.fish

# {{{ fd, fzf, rg
# A-c: cd
# C-t: complete path
# C-r: history
export FZF_DEFAULT_COMMAND='rg --files'
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--history=$HOME/.local/share/fzf_history"

#source "$HOME/.fzf/shell/key-bindings.fish"
source /usr/share/fzf/shell/key-bindings.fish
fzf_key_bindings

alias rg="rg --max-columns 999"
# }}}
