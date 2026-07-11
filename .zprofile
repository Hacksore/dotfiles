# can use this to import now
source "$HOME/scripts/utils.sh"
source "$HOME/scripts/aliases.sh"
source "$HOME/scripts/tmux.sh"

work_dir="$HOME/work"
if [ -d "$work_dir" ]; then
  source "$work_dir/init.sh"
fi
