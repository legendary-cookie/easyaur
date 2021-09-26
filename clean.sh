#!/bin/sh

for f in $(find . -maxdepth 1 -type d)
do
	[[ $f == "." ]] && continue
	[[ $f == ".git" ]] && continue
	rm -rf $f
done
