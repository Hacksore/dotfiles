# can use this to import now
source "$HOME/scripting/utils.sh"
source "$HOME/scripting/aliases.sh"
source "$HOME/scripting/tmux.sh"

work_dir="$HOME/work"
if [ -d "$work_dir" ]; then
  source "$work_dir/init.sh"
fi
