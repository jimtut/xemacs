#!/bin/sh
# *************************************************************************
# *************************************************************************
# Script Name:		mod-filename
# Author:			Jim Tuttle
# Function:			modify a filename
#
USAGE="mod-filename <search-string> <replace-string>\n\n\
THIS WORKS ON ALL FILES IN THE CURRENT DIRECTORY! "
# Notes:
#	- this script is RECURSIVE!
#	- you can change the search/replace strings to replace any characters
#		in the filename
#	
# Rev History:
#	29 Nov 99	Script created
#
# *************************************************************************
# *************************************************************************

if [ $# -lt 2 ]
then
	echo "USAGE: $USAGE"
	exit
fi

date_string=`date +%m%d%y%H%M%S`
search_string="$1"
replace_string="$2"

command="s/$search_string/$replace_string/g"
echo $command | cat > /tmp/sed-script.$date_string


source=`ls -1 | grep "$search_string" | head -1`
destination=`echo $source | sed -f /tmp/sed-script.$date_string`

if [ `ls -1 | grep "$search_string" | wc -l` -gt 0 ]
then
	echo "Moving '$source' to '$destination'."
	mv "$source" $destination
	$0 "$1" "$2"
else
	echo "No more replacements."
fi

rm -f /tmp/sed-script.$date_string