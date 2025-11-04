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

# TUI File manager is yazi. The following function is required to cd for the last picked dir:
function fm
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

# fuzzy find files by names with nvim
alias vff="nvim '+Telescope fd'"
# alias vff='nvim (fzf)'

alias less='less -F -N -R --use-color --line-num-width 3 --redraw-on-quit'
alias r='less'

# print last downloaded files
alias ldf 'echo $HOME/Downloads/(ls -trh ~/Downloads/ | tail -n1)'

# show list of recent files in nvim Telescope
alias rf='nvim -c "Telescope oldfiles"'
# show and copy full path of any file:
function rl; readlink -f $argv | wl-copy; wl-paste; end

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
# alias ga='git add'
# alias gam='git commit --ammend'
# alias gap='clear; git add -p'

starship init fish | source
# zoxide init fish | source

end # if status is-interactive

alias cal='date +%H:%M; /usr/bin/cal -w -m -y'
alias cal='date +%H:%M; /usr/bin/cal --week --columns=auto -my --color=always | less -RSn'

set LOCAL_CONFIG ~/.config/fish/config_local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end
