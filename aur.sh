#!/bin/sh
if [[ $# -eq 0 ]]
then
	echo "Provide the package to build!"
	exit
fi

echo "Building Package $1 from aur"

ROOT=$(pwd)

if [[ -d $1 ]]
then
	cd $1
	if [[ -f .AUR ]]
	then
		git pull
	else
		echo "$1 is not an AUR package!"
		exit
	fi
else
	git clone ssh://aur@aur.archlinux.org/$1 $1
	cd $1
	touch .AUR
fi

makepkg -sf
cp $1-*-$(uname -m).pkg.tar.* $ROOT/out
