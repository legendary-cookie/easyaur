#!/bin/bash

echo () {
	if [[ ! -z "$2" ]]
	then
		builtin echo "$@"
	else
#		builtin echo "$@" | tee -a /srv/logs/builder.log
		builtin echo "$@"
	fi
}


build () {

echo "Building: $1"
# Save pwd for later
ROOT=$(pwd)
echo "Current workdir: $ROOT"
# Create the out dir
mkdir -p $ROOT/out
# Gets current date for use as $now
now=$(date +'%d-%m-%Y-%r')
echo $now

# Checks if already cloned
if [[ -d $1 ]]
then
	cd $1
	[[ -f ".AUR" ]] && echo "$1 Is an AUR package!" && exit
	asp update
	git pull
else 
	asp export $1
	if [ $? -ne 0 ]; then
	   echo "Package '$1' does not exist / errors while cloning"
	   exit
	fi	
	cd $1
fi

if [[ -d "repos" ]]; then
	cd repos
	for f in **/PKGBUILD; do
		cd $(echo $f|sed 's/PKGBUILD//g')
		makepkg -sf --nocheck --skippgpcheck --sign
		cp  *.pkg.tar.* $ROOT/out
	done
fi

if [[ -f "PKGBUILD" ]]; then
	makepkg -sf --nocheck --skippgpcheck --sign
	cp  *.pkg.tar.* $ROOT/out
fi
}

if [[ $# -eq 0 ]]
then
        echo "Provide the package to build!"
        exit
fi

for pkg in "$@"
do
	build "$pkg"
done

wait
