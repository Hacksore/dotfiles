function d {
  local cmd=$1
  local varargs=${@:2}

  case $cmd in
    "l"|"link")
      cd $HOME/dotfiles
      stow .
      echo "Linked your dotfiles successfully!"
      ;;
    "u"|"unlink")
      cd $HOME/dotfiles
      stow -D .
      echo "Unlined your dotfiles successfully!"
      ;;
    *)
      echo "Command no known!"
      ;;
  esac
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
