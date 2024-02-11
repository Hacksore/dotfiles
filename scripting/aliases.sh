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

# reload the shell to source - might be better to use source command instead to save history
alias s="zsh"

# flush dns
alias dnsc="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# quick code
alias c="cd $HOME/Code"

# git pretty log
alias lg="git lg"

alias os="cd $HOME/Code/opensource"

alias ts="tmux-sessionizer"
