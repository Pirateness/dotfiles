#!/bin/bash
yay -S --needed - < pkglist.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for dir in "$SCRIPT_DIR"/*/; do
    dir_name="$(basename "$dir")"
    target="$HOME/.config/$dir_name"

    if [ -d "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}.bak"
        echo "Backed up existing $target to ${target}.bak"
    fi

    ln -sf "$dir" "$target"
done

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
