# dotfiles

These are my dotfiles, macOS user btw

### Setup

```bash
git clone --bare git@github.com:Hacksore/dotfiles.git $HOME/.cfg

function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

config checkout

if [ $? = 0 ]; then
  echo "Checked out dotfiles 😎";
else
    echo "🛑 Please backup/remove these files first!"
fi;

config checkout
config config status.showUntrackedFiles no
```