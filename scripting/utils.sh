# shellcheck disable=SC2207

function d {
	local cmd=$1

	case $cmd in
	"l" | "link")
		cd "$HOME/dotfiles" || exit 1
		stow_wrapper .
		echo "🔒 Linked your dotfiles successfully!"
		;;
	"u" | "unlink")
		cd "$HOME/dotfiles" || exit 1
		stow_wrapper -D .
		echo "🔓 Unlinked your dotfiles successfully!"
		;;
	"r" | "reload")
		cd "$HOME/dotfiles" || exit 1
		stow_wrapper -D . && stow_wrapper .
		echo "♻️  Reloaded your dotfiles successfully!"
		;;
	*)
		echo "[dotfiles] 🤔 Command not found!"
		echo "Try one of these:"
		echo "  d l|link - link dotfiles with stow"
		echo "  d u|unlink - unlink dotfiles with stow"
		echo "  d r|reload - reload dotfiles with stow"

		;;
	esac
}

# https://github.com/aspiers/stow/issues/65#issuecomment-1465060710
function stow_wrapper {
	stow "$@" 2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
}

function dotfiles {
	cd "$HOME/dotfiles" || exit 1
	echo "You have been moved to dotfiles directory 😎"
}

# creating this function to override the default env so we don't output anything starting with SECRET_ and OP_
function env {
	normalOutput=$(command env)
	echo $normalOutput | awk '$0 !~ /SECRET_|OP_/'
}

# nice timeing func
function timezsh {
	shell=${1-$SHELL}
	for _i in $(seq 1 10); do /usr/bin/time "$shell" -i -c exit; done
}

# very useful command for monorepos where you switch branch a lot and old dirs are left behind
function gitclean {
	# Find all directories that are not ignored by git and store them in an array
	ignored_dirs=($("git ls-files --others --exclude-standard --directory"))
	# Loop through all directories that are not ignored by git
	for dir in "${ignored_dirs[@]}"; do
		# Check if the directory contains any non-gitignored files/folders
		if [[ -z $(git ls-files --directory "$dir") ]]; then
			# If the directory contains only gitignored files/folders, remove it
			echo "removing $dir"
			rm -rf "$dir"
		fi
	done
}

function astro {
	cd "$HOME/dotfiles/.config/astronvim" || exit 1
	nvim .
}

function canary {
	download_url=$(curl -s https://update.overlayed.dev/latest/canary | jq -r '.downloads[] | select(.platform == "mac") | .url')

	# download the latest canary build
	wget -O /tmp/overlayed-canary.zip "$download_url"

	# unzip the file
	unzip -o /tmp/overlayed-canary.zip -d /tmp/overlayed-canary

	# remove the old app
	killall "Overlayed Canary"

	# remove the old app
	rm -rf /Applications/Overlayed\ Canary.app

	# mount the dmg file
	hdiutil attach /tmp/overlayed-canary/Overlayed\ Canary_0.0.0-canary.*_universal.dmg

	# copy the app to the applications folder
	cp -R /Volumes/Overlayed\ Canary/Overlayed\ Canary.app /Applications

	# unmount the dmg file
	hdiutil detach /Volumes/Overlayed\ Canary

	# remove the zip and the extracted folder
	rm -rf /tmp/overlayed-canary.zip /tmp/overlayed-canary

	# remove xattr quaruatine
	xattr -r -d com.apple.quarantine /Applications/Overlayed\ Canary.app
}
