# vi: ft=sh

if status is-interactive
# Commands to run in interactive sessions can go here

# Don't print greeting when start
set fish_greeting ""

set -x PATH /usr/local/bin $PATH
set -x PATH $PATH ~/.bin/
set -x PATH $PATH ~/.cargo/bin/
#set -x PATH $PATH ~/.bin/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-apple-darwin/bin

export LC_ALL=en_US.UTF-8
export EDITOR=(which nvim)

#############################################################################
# common aliases
#
#alias fd="fdfind"
alias r='nvim -R -'

# Directory listing
function ll
    exa -l --classify --color=always $argv | less -F -N -R --use-color
end
function llt
    exa -l --classify --sort=modified --color=always $argv | less -F -N -R --use-color
end
function tree
    exa --tree --classify --color=always $argv | less -F -N -R --use-color
end
alias t=tree

# Git aliases
alias gdc='clear; git diff --cached'
alias gd='clear; git diff'
alias gst='clear; git status'
alias ga='git add'
alias gam='git commit --ammend'
alias gap='clear; git add -p'

alias cal='date +%H:%M; ncal -w -s DE -M -b -y'

starship init fish | source
zoxide init fish | source

end
