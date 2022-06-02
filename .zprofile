export GHREPOS="$HOME/Code"

alias workTreeGit="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

function configHelpBanner {
  echo "💻 Config helper"
  echo "u/update     - Update your config, will add all changes files, commit, and push";
  echo "h/help       - show the help menu" 
  echo "p/pull/sync  - pull the latest changes down from remote" 
  echo "s/status     - get the git status" 
  echo "d/diff       - get the git diff"
}

function c {
  local cmd=$1
  local varargs=${@:2}

  case $cmd in
    "u"|"update")
      commitMessage=""

      if [[ $varargs != "" ]]; then
        commitMessage=$varargs
        echo "Using message for commit: $varargs"
      else
        echo "Enter a commit message:"
        vared -p '' -c commitMessage        
      fi

      workTreeGit add -u . &&
      workTreeGit commit -m "$commitMessage" &&
      workTreeGit push &&
      echo "Updated config successfully!"
      ;;
    "p"|"pull"|"sync")
      workTreeGit pull
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

