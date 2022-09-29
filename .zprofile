export GHREPOS="$HOME/Code"

# alias to open this file
alias profile="code $HOME/.zshrc"

function dotfiles {
  cd $HOME/dotfiles
  echo "You have been moved to dotfiles directory 😎"
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

# Create testing vite project
function new-vite {
  randomStr=$(openssl rand -hex 8 | head -c 8)
  randomPath="/tmp/$USERNAME/sandbox/vite"
  fullPath="$randomPath/p$randomStr"

  mkdir -p "$randomPath"
  
  cd $randomPath
  npm create vite@latest "p$randomStr" -- --template react-ts

  cd "$fullPath"

  yarn

  code .
  code "$fullPath/src/App.tsx"
}
