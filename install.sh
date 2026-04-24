#!/bin/bash
yay -S --needed - < pkglist.txt

git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
~/.config/emacs/bin/doom install
