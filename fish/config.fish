# Shortcuts: https://fishshell.com/docs/current/#shared-bindings
# Alt-e ... edit command line in an editor
fish_vi_key_bindings

set PATH ~/go/bin $PATH
set PATH ~/.local/bin $PATH
set PATH ~/bin $PATH
set PATH ~/dev/scripts $PATH

set -gx EDITOR $HOME/bin/editor.sh

set -gx PAGER less
set -gx LESS "--RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen --LONG-PROMPT --shift=5"
set -gx SYSTEMD_LESS $LESS

set __fish_machine ""

alias copyq="~/dev/build/copyq/release/copyq"

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

alias w0="~/dev/scripts/work.sh off"
alias w1="~/dev/scripts/work.sh on"

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

if test -f /usr/share/autojump/autojump.fish
    source /usr/share/autojump/autojump.fish
end

# A-c: cd
# C-t: complete path
# C-r: history
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc
export FZF_DEFAULT_COMMAND='rg --files'
#export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--history=$HOME/.local/share/fzf_history"

if test -f /usr/share/fzf/shell/key-bindings.fish
    source /usr/share/fzf/shell/key-bindings.fish
    fzf_key_bindings
end

alias rg="rg --max-columns 999"
