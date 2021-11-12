#!/bin/sh

for f in $(find $HOME/.pkgbuilder/out/ -type f ! -name "*.sig")
do
	add2repo $f
done
