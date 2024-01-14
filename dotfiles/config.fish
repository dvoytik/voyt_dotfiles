# vi: ft=sh

if status is-interactive
# Commands to run in interactive sessions can go here

# execute sway on the first virtual terminal
set TTY1 (tty)
if test "$TTY1" = "/dev/tty1"
    exec sway
    # startx
end

# Don't print greeting when start
set fish_greeting ""

set -x PATH $PATH ~/.bin/
set -x PATH $PATH ~/.cargo/bin/
set -x PATH $PATH ~/.local/bin/

export LC_ALL=en_US.UTF-8
export EDITOR=(which nvim)

#############################################################################
# common aliases
#
#alias fd="fdfind"
alias v=nvim

alias less='less -F -N -R --use-color --line-num-width 3 --redraw-on-quit'
alias r='less'

alias ff="nvim '+Telescope fd'"

# Directory listing
function ll
    exa -l --classify --color=always $argv | less
end
function llt
    exa -l --classify --sort=modified --color=always $argv | less
end
function tree
    exa --tree --classify --color=always $argv | less
end
alias t=tree

# Git aliases
alias gdc='clear; git diff --cached'
alias gd='clear; git diff'
alias gst='clear; git status'
alias ga='git add'
alias gam='git commit --ammend'
alias gap='clear; git add -p'

starship init fish | source
# zoxide init fish | source

end # if status is-interactive

alias cal='date +%H:%M; /usr/bin/cal -w -m -y'

set LOCAL_CONFIG ~/.config/fish/config_local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end
