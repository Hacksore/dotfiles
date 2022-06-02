export GHREPOS="$HOME/Code"

alias workTreeGit="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

function configHelpBanner {
  echo "# CONFIG HELP MENU"
  echo "u/update - Update your config, will add all changes files, commit, and push";
  echo "h/help - show the help menu" 

}

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
      configHelpBanner
      ;;
    "s"|"status")
      workTreeGit status
      ;;
    "d"|"diff")
      workTreeGit diff
      ;;
    *)
      workTreeGit
      ;;
  esac

}

alias config="c"

function plug {
  nvim $HOME/.config/nvim/lua/plugins.lua
}

function p {
  nvim $GHREPOS
}


# useful aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias v="nvim"
alias emacs="nvim"

# reload the shell to source - might be better to use source command instead to save history
alias s="zsh"

# creating this function to override the default env so we don't output anything starting with SECRET_ and OP_
function env {
  normalOutput=$(command env)
  
  echo $normalOutput | awk '$0 !~ /SECRET_|OP_/'

}

