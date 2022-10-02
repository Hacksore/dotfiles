# define this here xd
function import {
  local file=$1
  # source the file
  source "$HOME/dotfiles/scripting/$file"
}

# can use this to import now
import "op.sh"
import "utils.sh"
import "aliases.sh"
import "scaffolding.sh"
