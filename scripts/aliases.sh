# shellcheck disable=SC2139

# alias to open this file
alias profile="code $HOME/.zshrc"

# useful aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gd="git diff"
# alias v="nvim"
# alias vim="nvim"
# alias vi="nvim"

# reload the shell without nesting another process
alias s="exec zsh"

# flush dns
alias dnsc="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# quick code; use the terminal's ANSI palette instead of Codex's RGB syntax theme
alias c="codex --yolo --config 'tui.theme=\"ansi\"'"

# git pretty log
alias lg="git lg"

alias os="cd $HOME/Code/opensource"

alias ts="tmux-sessionizer"
