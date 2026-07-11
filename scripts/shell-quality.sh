#!/usr/bin/env bash

set -euo pipefail

usage() {
	cat <<'EOF'
Usage: scripts/shell-quality.sh <format|check|lint|list|list-lint>

Runs shell formatting and linting over repo shell files.
EOF
}

is_shell_shebang() {
	local file=$1
	local first_line

	IFS= read -r first_line <"$file" || return 1

	case "$first_line" in
	"#!"*"/sh" | "#!"*"/sh "* | "#!"*"/bash" | "#!"*"/bash "* | "#!"*"env sh" | "#!"*"env sh "* | "#!"*"env bash" | "#!"*"env bash "* | "#!"*"/zsh" | "#!"*"/zsh "* | "#!"*"env zsh" | "#!"*"env zsh "*)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

is_zsh_file() {
	local file=$1
	local first_line

	IFS= read -r first_line <"$file" || return 1

	case "$first_line" in
	"#!"*"/zsh" | "#!"*"/zsh "* | "#!"*"env zsh" | "#!"*"env zsh "*)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

is_shell_file() {
	local file=$1

	case "$file" in
	*.sh)
		return 0
		;;
	esac

	is_shell_shebang "$file"
}

collect_files() {
	local include_zsh=$1
	local files=()
	local file

	while IFS= read -r -d '' file; do
		[[ -f "$file" ]] || continue
		is_shell_file "$file" || continue

		if [[ "$include_zsh" != "true" ]] && is_zsh_file "$file"; then
			continue
		fi

		files+=("$file")
	done < <(git ls-files -z --cached --others --exclude-standard)

	printf '%s\0' "${files[@]}"
}

run_with_files() {
	local include_zsh=$1
	shift

	local files=()
	local file

	while IFS= read -r -d '' file; do
		files+=("$file")
	done < <(collect_files "$include_zsh")

	if [[ ${#files[@]} -eq 0 ]]; then
		return 0
	fi

	"$@" "${files[@]}"
}

command=${1:-}

case "$command" in
format)
	run_with_files true shfmt -w
	;;
check)
	run_with_files true shfmt -d
	;;
lint)
	run_with_files false shellcheck -s bash
	;;
list)
	collect_files true | tr '\0' '\n'
	;;
list-lint)
	collect_files false | tr '\0' '\n'
	;;
*)
	usage
	exit 1
	;;
esac
