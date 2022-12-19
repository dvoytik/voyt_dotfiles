
if status is-interactive
# Commands to run in interactive sessions can go here

set -x PATH /usr/local/bin $PATH
set -x PATH $PATH ~/.bin/
set -x PATH $PATH ~/.cargo/bin/
#set -x PATH $PATH ~/.bin/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-apple-darwin/bin

export LC_ALL=en_US.UTF-8

#
# common aliases
#
alias fd="fdfind"
alias r='vim -R -'

alias gdc='clear; git diff --cached'
alias gd='clear; git diff'
alias gst='clear; git status'
alias ga='git add'
alias gam='git commit --ammend'
alias gap='clear; git add -p'

alias t='tree . | vim -'

alias llt="ls -ltrh"


starship init fish | source

end
