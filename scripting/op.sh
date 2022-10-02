# 1Password cli helper util that will check if you are logged in
# then try using op run with a env file
function sec {
  who=$(op whoami)
  
  # ask for login if not signed in
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