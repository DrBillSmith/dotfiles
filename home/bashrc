#
# ~/.bashrc
#

eval "$(starship init bash)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$HOME/.cargo/bin:$PATH"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

cdl() {
	cd "$@" && ls;
}

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Created by `pipx` on 2025-07-24 21:49:10
export PATH="$PATH:/home/drbillsmith/.local/bin"

fastfetch
