#!/bin/sh
if [[ $# -eq 0 ]]
then
	echo "Provide the package to build!"
	exit
fi

echo "Building Package $1 from aur"

ROOT=$(pwd)
mkdir -p $ROOT/out

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
	if [[ -e "PKGBUILD" ]]; then
		echo "Valid AUR package!"
	else
		cd ..
		rm -rf $1
		echo "Package does not exist on the AUR"
		exit
	fi
fi

makepkg -sf

cp  *.pkg.tar.* $ROOT/out
