#!/bin/bash

PATH="$1"

convert(){
	FILE="$1"
	echo "$FILE" | grep '.md'
	IS_MD_FILE="$?"
	
	if [ $IS_MD_FILE -eq "0" ] then
		FILE_NAME=`echo $FILE | cut -f1 -d.`
		pandoc -f markdown -t html5 $FILE > ${FILE_NAME}.html
	else 
		echo "$FILE is not markdown file... skip it..."
	fi
}

convert_dir(){
	FILES=`ls $1`
	for FILE in $FILES
	do
		if [ -d $FILE ] then
			convert $FILE
		else
			convert_dir $FILE
		fi
	done
}

convert_dir $PATH