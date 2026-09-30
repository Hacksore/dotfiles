work_dir="$HOME/work"
if [ -d "$work_dir" ] && [ -z "${WORK_INIT_SH_LOADED:-}" ]; then
  export WORK_INIT_SH_LOADED=1
  source "$work_dir/init.sh"
fi
