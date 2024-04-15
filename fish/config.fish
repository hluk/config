# Shortcuts: https://fishshell.com/docs/current/#shared-bindings
# Alt-e ... edit command line in an editor
fish_vi_key_bindings

set PATH ~/go/bin $PATH
set PATH ~/.local/bin $PATH

set -gx EDITOR $HOME/bin/editor.sh

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

alias g="git"
alias gc="git co"
alias gd="git d"
alias gf="git f"
alias gs="git show"
alias gst="git st"
alias gu="git up"
# alias gg="lazygit"
alias gg="gitui"
# alias gg="flatpak run com.github.Murmele.Gittyup"
alias gpr="git pr"

set fish_greeting

# starship init fish | source

source /usr/share/autojump/autojump.fish

# A-c: cd
# C-t: complete path
# C-r: history
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
export FZF_DEFAULT_COMMAND='rg --files'
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--history=$HOME/.local/share/fzf_history"

source /usr/share/fzf/shell/key-bindings.fish
fzf_key_bindings

alias rg="rg --max-columns 999"
