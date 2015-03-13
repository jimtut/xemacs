#!/bin/csh -f

# *************************************************************************
# *************************************************************************
# Script Name:		replace
# Author:		Jim Tuttle
# Function:		Finds text within a file, and replaces it!
#
# Usage:		
# Notes:		
#	
# Rev History:
#	Summer 1996	Script created
#	10 Jun 98	Added grep before the sed script
#
# *************************************************************************
# *************************************************************************


if ($#argv < 3) then
	if ($#argv < 2) then
		if ($#argv < 1) then
			\echo "Search for: \c"
			set search = $<
		else
			set search = `echo $1`
		endif
		\echo "Replace '$search' with: \c"
		set replace = $<
	else
		set search = `echo $1`
		set replace = `echo $2`
	endif
	\echo "Enter filename (wildcards acceptable): \c"
	set filelist = $<
else
# You MUST set these variables with the 'echo' command!
# Assigning them directly to the command-line arguments
# only passes the *first* word of each argument.
# We very often have multi-word arguments when finding/replacing.
	set search = `echo $1`
	set replace = `echo $2`
	set filelist = `echo $3`
endif

set date_string = `date +%m%d%y%H%M%S`
set command = "s/$search/$replace/g"
echo $command | cat >! /tmp/sed-script.$date_string

foreach file ($filelist)
	if { grep "$search" $file > /dev/null } then
		echo " "
		echo "Trying to replace '$search' in '$file'...."
		if { sed -f /tmp/sed-script.$date_string $file > /tmp/$file } then
			mv /tmp/$file $file
			echo "....replaced '$search' with '$replace'."
		endif
	endif
end

rm -f /tmp/sed-script.$date_string

#echo $file | xargs sed 's/$search/$replace/'

