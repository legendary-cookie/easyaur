#!/bin/bash
#########################################
#   COPYRIGHT 2021 VINCENT SCHWEIGER	#
#   THIS SCRIPT IS LICENSED UNDER THE	#
#	COSMO LICENSE.			#
#	RESPECT IT IN ANY WAY.		#
#########################################

# Program info
ProgName=$(basename $0)
# Colors
bold="$(tput bold)"
red="$(tput setaf 160)"
boldred="$bold$red"
# Locs
aurloc="$HOME/.aurpkgs"
offloc="$HOME/.pkglist"
# Functions and main logic
echo () {
	if [[ ! -z "$2" ]]
	then
		builtin echo "$@"
	else
		builtin echo "$@"
	fi
}

pkg(){
	makepkg
}

sub_help(){
	echo "Usage: $ProgName <subcommand> [options]"
	echo "Subcommands:"
	echo "	build	Build a package"
	echo "	refreshcaches	Refresh the package lists"
	echo ""
	echo "For help with each subcommand run:"
	echo "$ProgName <subcommand> -h|--help"
	echo ""
}

sub_refreshcaches(){
        wget https://aur.archlinux.org/packages.gz -O - | gunzip > $aurloc
        pacman -Sql core community extra multilib > $offloc
}

move_built_pkgs() (
	cp  *.pkg.tar.* $ROOT/out
)

aurbuild () {
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
		echo "$1 is not an AUR package! Try deleting the folder $(realpath $1)"
		exit 1
	fi
else
	#git clone ssh://aur@aur.archlinux.org/$1 $1
	if git clone "https://aur.archlinux.org/$1.git/" "$1"
	then
	cd $1
	touch .AUR
	if [[ ! -e "PKGBUILD" ]]; then
		cd ..
		rm -rf $1
		echo $boldred"$1 is not available on the AUR!"
		echo $boldred"Try refreshing your package cache (refreshcache subcommand)"
		exit 1
	fi
	else
		echo $boldred"Error cloning from the AUR!"
		exit 1
	fi
fi

pkg
move_built_pkgs

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
echo "$now"

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

if [[ -f "PKGBUILD" ]]; then
	pkg
	if [[ ! $? == 0 ]]; then
                echo $boldred"ERROR: Operation failed"
                exit 1
	else
		move_built_pkgs
	fi
fi

cd $ROOT
}

sub_build(){

if [[ $# -eq 0 ]]
then
        echo "Provide the package to build!"
        exit 1
fi

for pkg in "$@"
do
	if grep -Fxq "$pkg" "$HOME/.pkglist"
	then
		echo "Building official package ..."
		build "$pkg"		
	else 
		if grep -Fxq "$pkg" "$HOME/.aurpkgs"
		then
			echo "Building AUR package ..."
			aurbuild "$pkg"
		else
			echo $boldred"The specified package does not exist on the AUR nor on the normal repos!"
		fi
	fi
done

}


subcommand=$1
case $subcommand in
    "" | "-h" | "--help")
        sub_help
        ;;
    *)
        shift
        sub_${subcommand} $@
        if [ $? = 127 ]; then
            echo "Error: '$subcommand' is not a known subcommand." >&2
            echo "       Run '$ProgName --help' for a list of known subcommands." >&2
            exit 1
        fi
        ;;
esac
