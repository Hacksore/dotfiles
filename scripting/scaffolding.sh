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
