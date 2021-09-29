#!/bin/sh
echo "Importing all keys...."
gpg --import /usr/share/pacman/keyrings/archlinux.gpg >/dev/null 2>&1
echo "Imported all keys!"
