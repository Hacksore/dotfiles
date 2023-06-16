function d {
  local cmd=$1

  case $cmd in
    "l"|"link")
      cd $HOME/dotfiles
      stow_wrapper .
      echo "🔒 Linked your dotfiles successfully!"
      ;;
    "u"|"unlink")
      cd $HOME/dotfiles
      stow_wrapper -D .
      echo "🔓 Unlinked your dotfiles successfully!"
      ;;
    "r"|"reload")
      cd $HOME/dotfiles
      stow_wrapper -D . && stow_wrapper .
      echo "♻️  Reloaded your dotfiles successfully!"
      ;;
    *)
      echo "[dotfiles] 🤔 Command not found!"
      echo "Try one of these:"
      echo "  d l|link - link dotfiles with stow"
      echo "  d u|unlink - unlink dotfiles with stow"
      echo "  d r|reload - reload dotfiles with stow"

      ;;
  esac
}

# https://github.com/aspiers/stow/issues/65#issuecomment-1465060710
function stow_wrapper {
  stow "$@" 2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
}

function dotfiles {
  cd $HOME/dotfiles
  echo "You have been moved to dotfiles directory 😎"
}

# creating this function to override the default env so we don't output anything starting with SECRET_ and OP_
function env {
  normalOutput=$(command env)
  echo $normalOutput | awk '$0 !~ /SECRET_|OP_/'
}

# nice timeing func
function timezsh {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

# very useful command for monorepos where you switch branch a lot and old dirs are left behind
function gitclean {
  # Find all directories that are not ignored by git and store them in an array
  ignored_dirs=($(git ls-files --others --exclude-standard --directory))
  # Loop through all directories that are not ignored by git
  for dir in "${ignored_dirs[@]}"; do
    # Check if the directory contains any non-gitignored files/folders
    if [[ -z $(git ls-files --directory "$dir") ]]; then
      # If the directory contains only gitignored files/folders, remove it
      echo "removing $dir"
      rm -rf "$dir"
    fi
  done
}

function astro {
  cd "$HOME/dotfiles/.config/astronvim"
  nvim .
}
