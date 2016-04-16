# General {{{
# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
#set fish_theme numist
#agnoster
#agnoster-mercurial
#beloglazov
#bira
#bobthefish
#budspencer
#clearance
#coffeeandcode
#cor
#edan
#fishface
#fishy-drupal
#gianu
#gitstatus
#idan
#integral
#jacaetevha
#krisleech
#l
#mtahmed
#numist
#ocean
#perryh
#robbyrussell
#simplevi
#syl20bnr
#toaster
#uggedal
#yimmy
#zish

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-fish/plugins/*)
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Example format: set fish_plugins autojump bundler
set fish_plugins \
  autojump \
  pacman

# Path to your custom folder (default path is $FISH/custom)
#set fish_custom $HOME/dotfiles/oh-my-fish

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

set fish_greeting ""
# }}}

# Aliases {{{
alias m="smplayer"
alias copyq=~/dev/build/copyq/debug/install/bin/copyq

# yaourt
alias q="yaourt"
alias i="q -S"
alias u="q -Rs"
alias qdiff="q -C"
alias up="q -Syu --aur"
alias clean="q -Qdt"
# }}}

# Functions {{{
function f -d "simple find" -a name path
    find $path -iname "*$name*"
end

function e -d "open editor in GNU screen in new window"
    #screen -t ">$*" vim "$@"
    tmux new-window -n ">$argv" "vim \"$argv\""
end

function mkcd -d "make directory if it does not exist and cd to it"
    mkdir -p $argv
    and cd $argv
end

function topp -d "'top' for processes with given names"
    htop -p (pidof $argv | tr ' ' ,)
end
# }}}

# Theme {{{
function fish_prompt
  set -l last_status $status

  # Colours
  set -l hostname_color (set_color -o 6EC9DD)
  set -l error_color (set_color -o F92672)
  set -l path_color (set_color -o A6E22E)
  set -l white (set_color white)
  set -l normal_color (set_color normal)
  set -l prompt_color (set_color -o F92672)

  # Unconditional stuff
  set -l path $path_color(pwd | sed "s:^$HOME:~:")
  set -l basic_prompt $prompt_color(whoami)$white@$hostname_color(hostname -s) $path_color$path" "

  # Git stuff
  set -l git_info
  if [ (command git rev-parse --is-inside-work-tree ^/dev/null) ]
    # Get the current branch name/commit
    set -l git_branch_name (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
    if [ -z $git_branch_name ]
      set git_branch_name (command git show-ref --head -s --abbrev | head -n1 2> /dev/null)
    end

    # Unconditional git component
    set git_info "$white$git_branch_name"

    set git_info "$git_info "
  end

  # Last command
  set -l errors ""
  if [ $last_status -ne 0 ]
    set errors "$error_color""[$last_status]"
  end

  echo -n -s "$basic_prompt$git_info$errors$prompt_color> $normal_color"
end
# }}}

set EDITOR -Ux "vim"

# autojump
source /etc/profile.d/autojump.fish

# ccache
set -x PATH /usr/lib/ccache/bin $PATH
ccache --max-size=8G >/dev/null

# support colors in less and man
set -x LESS_TERMCAP_mb \e'[01;31m'
set -x LESS_TERMCAP_md \e'[01;33m'
set -x LESS_TERMCAP_me \e'[0m'
set -x LESS_TERMCAP_se \e'[0m'
set -x LESS_TERMCAP_so \e'[01;44;33m'
set -x LESS_TERMCAP_ue \e'[0m'
set -x LESS_TERMCAP_us \e'[01;32m'

set fish_new_pager 1
