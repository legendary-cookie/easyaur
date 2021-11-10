#!/bin/sh

for f in $(find out/ -type f ! -name "*.sig")
do
	add2repo $f
done
