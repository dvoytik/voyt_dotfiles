
set -x PATH /usr/local/bin $PATH
set -x PATH $PATH ~/.bin/
set -x PATH $PATH ~/.cargo/bin/

export LC_ALL=en_US.UTF-8

#
# common aliases
#
alias r='vim -R -'

alias gdc='clear; git diff --cached'
alias gd='clear; git diff'
alias gst='clear; git status'
alias ga='git add'
alias gam='git commit --ammend'
alias gap='clear; git add -p'

alias t='tree . | vim -'
