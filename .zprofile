work_dir="$HOME/work"
if [ -d "$work_dir" ] && [ -z "${_WORK_INIT_SH_LOADED_IN_THIS_SHELL:-}" ]; then
  _WORK_INIT_SH_LOADED_IN_THIS_SHELL=1
  source "$work_dir/init.sh"
fi
