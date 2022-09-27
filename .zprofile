export GHREPOS="$HOME/Code"

# add cargo to path
export PATH="$HOME/.cargo/bin/:$PATH"

alias workTreeGit="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

function configHelpBanner {
  echo "💻 Config helper"
  echo "u/update     - update your config, will add all changes files, commit, and push"
  echo "h/help       - show the help menu"
  echo "p/pull/sync  - pull the latest changes down from remote" 
  echo "s/status     - get the git status" 
  echo "d/diff       - get the git diff"
  echo "g/github     - load the repo in browser"
}

function git {
  local cmd=$1
  local brewPath=$(brew --prefix)
  local gitcmd="$brewPath/bin/git"
  local bold=$(tput bold)
  local varargs=$@

  case $cmd in
    "reset")
      echo "🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑"
      echo "🛑     ${bold}YOU ARE ABOUT TO COMMIT DANGER TO THE REPO!      🛑"
      echo "🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑🛑"

      if read -q "choice?Press Y/y to continue with the DANGER git reset: "; then
        echo
        echo "Continuing with command 'git $varargs' ..."
        echo 
        $gitcmd "$@"
      else
        echo
        echo "'$choice' not 'Y' or 'y'. SAVING YOU BRO 😅..."
      fi
      ;;
    *)
      $gitcmd $@
      ;;
  esac

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
      
      # TODO: this isnt working for some reason
      workTreeGit add -u "$HOME" &&
      workTreeGit commit -m "$commitMessage" &&
      workTreeGit push &&
      echo "Updated config successfully!"
      ;;
    "p"|"pull"|"sync")
      workTreeGit pull
      workTreeGit submodule update --recursive --remote
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
    "e"|"edit")
      code $HOME/.zprofile
      ;;
    "g"|"goto"|"github")
      open "https://github.com/Hacksore/dotfiles"
      ;;
    *)
      workTreeGit $@
      ;;
  esac

}

alias config="c"

function plug {
  code $HOME/.config/code/lua/plugins.lua
}

function p {
  code $GHREPOS
}

# 1Password cli helper util
function sec {
  who=$(op whoami)
  
  # ask for login if no signed in
  if [[ $? != 0 ]]; then 
    eval $(op signin)
  fi

  # Check if we have a file in the PWD first and use that
  if [[ -f "$PWD/.env" ]]; then
    op run --env-file=$PWD/.env -- $@
  else
    op run --env-file=$HOME/personal/.env -- $@
  fi  
}

# useful aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias v="code"
alias emacs="code"

# reload the shell to source - might be better to use source command instead to save history
alias s="zsh"

# creating this function to override the default env so we don't output anything starting with SECRET_ and OP_
function env {
  normalOutput=$(command env)
  echo $normalOutput | awk '$0 !~ /SECRET_|OP_/'
}

# Create testing rust project
function new-rust {
  randomStr=$(openssl rand -hex 8)
  randomPath="/tmp/$USERNAME/sandbox/rust/p$randomStr"

  cargo new "$randomPath"

  cd "$randomPath" && code .
  code "$randomPath/src/main.rs"
}

# creating testing ts project
function new-ts {
  randomStr=$(openssl rand -hex 12 | head -c 8)
  randomPath="/tmp/$USERNAME/sandbox/typescript/p$randomStr"

  mkdir -p "$randomPath"

  cd "$randomPath" && npx --package typescript tsc --init
  
  mkdir -p "$randomPath/src"
  echo "console.log(69)" >> "$randomPath/src/index.ts"

  code .
  code "$randomPath/src/index.ts"
}