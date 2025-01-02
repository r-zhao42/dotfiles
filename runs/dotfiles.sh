#!/usr/bin/env bash

script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

mkdir -p "$HOME/.config"

cp -R "$script_dir/.config/" "$HOME/.config/"

cp "$script_dir/.zshrc" "$HOME"
