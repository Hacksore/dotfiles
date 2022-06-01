export GHREPOS="$HOME/Code"

function c {
  config submodule update --remote --init --recursive
}

function p {
  nvim $GHREPOS
}

function config {
  git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

function cu {
  config add -u .
}

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias v="nvim"
alias emacs="nvim"
alias s="zsh"
