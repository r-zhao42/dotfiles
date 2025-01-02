#!/usr/bin/env bash

script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
filter=""
dry="0"

while [[ $# > 0 ]]; do
	if [[ $1 == "--dry" ]]; then
		dry="1"
	else
		filter="$1"
	fi
	shift
done

log() {
	if [[ $dry == "1" ]]; then
		echo "[DRY RUN]: $@"
	else
		echo "$@"
	fi
}

execute() {
	log "Execute $@"
	if [[ $dry == "1" ]]; then
		return
	fi
	"$@"
}

cd $script_dir

echo "$HOME"

if echo $(brew help) | grep -q "command not found"; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	log "Homebrew is installed"
fi

scripts=$(find runs -maxdepth 1 -mindepth 1 -type f)

for script in $scripts; do
	if echo "$script" | grep -qv "$filter"; then
		log "filtering $script"
		continue
	fi

	execute ./$script
done
