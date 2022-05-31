export GHREPOS="$HOME/Code"

function c {
  config submodule update --remote --init --recursive
}

function p {
  nvim $GHREPOS
}

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
