#!/bin/sh

for f in $(find out/ -type f)
do
	add2repo $f
done
