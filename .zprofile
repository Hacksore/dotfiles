export GHREPOS="$HOME/Code"

alias workTreeGit="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

function c {
  local cmd=$1

  case $cmd in
    "u"|"update")
      vared -p 'Enter a commit message: ' -c commitMessage
      workTreeGit add -u . &&
      workTreeGit commit -m "$commitMessage" &&
      workTreeGit push &&
      echo "Updated config successfully!"
      ;;
    "h"|"help")
      echo "Help menu: TODO implement"
      ;;
    "s"|"status")
      workTreeGit status
      ;;
    "d"|"diff")
      workTreeGit diff
      ;;
    *)

      git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
      echo "Option not recognized"
      ;;
  esac

}

alias config="c"
# CONFIG END FUNCS

function plug {
  nvim $HOME/.config/nvim/lua/plugins.lua
}

function p {
  nvim $GHREPOS
}

alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias v="nvim"
alias emacs="nvim"
alias s="zsh"
