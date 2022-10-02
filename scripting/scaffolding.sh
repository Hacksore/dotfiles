# TODO: create this into a nice cli tool

function scaffoldRandomString {
  local projectType=$1
  randomStr=$(openssl rand -hex 12 | head -c 8)
  randomPath="$HOME/s/$projectType/p$randomStr"

  mkdir -p "$randomPath"

  echo "$randomPath"
}

# Create testing rust project
function new-rust {
  randomPath=$(scaffoldRandomString "rust")

  cargo new "$randomPath"

  cd "$randomPath" && code .
  code "$randomPath/src/main.rs"
}

# creating testing ts project
function new-ts {
  randomPath=$(scaffoldRandomString "ts")

  mkdir -p "$randomPath"

  cd "$randomPath" && npx --package typescript tsc --init
  
  mkdir -p "$randomPath/src"
  echo "console.log(69)" >> "$randomPath/src/index.ts"

  code .
  code "$randomPath/src/index.ts"
}

# Create testing vite project
function new-vite {
  randomPath=$(scaffoldRandomString "vite")
  fullPath="$randomPath/p$randomStr"

  mkdir -p "$randomPath"
  
  cd $randomPath
  npm create vite@latest "p$randomStr" -- --template react-ts

  cd "$fullPath"

  yarn

  code .
  code "$fullPath/src/App.tsx"
}
