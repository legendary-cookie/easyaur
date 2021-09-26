#!/bin/sh

if [[ $# -eq 0 ]]
then
	echo "Provide the package to build!"
	exit
fi

echo "Building $1"

ROOT=$(pwd)

if [[ -d $1 ]]
then
	cd $1
	[[ -f ".AUR" ]] && echo "$1 Is an AUR package!" && exit
	asp update
	git pull
else 
	asp export $1
	if [ $? -ne 0 ]; then
	   echo "Package $1 does not exist / errors while cloning"
	   exit
	fi	
	cd $1
fi

if [[ -d "repos" ]]; then
	cd repos
	for f in **/PKGBUILD; do
		cd $(echo $f|sed 's/PKGBUILD//g')
		makepkg -sf
		cp $1-*-$(uname -m).pkg.tar.* $ROOT/out
	done
fi

if [[ -f "PKGBUILD" ]]; then
	makepkg -sf
	cp $1-*-$(uname -m).pkg.tar.* $ROOT/out
fi
