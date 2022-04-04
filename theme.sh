#!/bin/bash

# Check we got a param for the theme
if [ $# -eq 0 ]; then
	echo "Didn't pass a theme name"
	exit
fi

dirpath=$(dirname "$0")/hyper-themes/"$1"

# Check that the theme recieved actually exists
if [ ! -d "$dirpath" ]; then
	echo "Theme Doesn't exist"
	exit
fi

# Based on the system detected set outPath and inPath
# Then we'll copy the inpath into the outpath
unameOut="$(uname -s)"
case "$unameOut" in 
	MSYS*) echo "Msys environment detected" ;
		outPath=$(cygpath "$APPDATA/Hyper/.hyper.js") ;
		inPath=$(cygpath "$dirpath/win.js") ;;
	*) 	echo "Unknown uname value" ;
		exit
esac

cp $inPath $outPath
echo "Hyper theme updated"