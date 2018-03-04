#!/bin/bash

echo "param: $1"

DIR="$1"

function convert(){
	FILE="$1"
	echo "[INFO] convert $FILE"
	echo "$FILE" | grep '.md'
	IS_MD_FILE="$?"
	
	if [ "$IS_MD_FILE" == "0" ]
	then
	    echo "[INFO] converting file: $FILE"
		HTML_NAME=`echo ${FILE} | sed 's/\.md/\.html/g'`
		echo "[INFO] html file: $HTML_NAME"
		pandoc -f markdown -t html5 ${FILE} > ${HTML_NAME}

        chmod 766 "${HTML_NAME}"
		# 将文件内容中的.md转换为.html
		cat ${HTML_NAME} | while read line
		do
		    sed -i -e "s/\.md/\.html/g" ${HTML_NAME}
		done

	else
		echo "[INFO] $FILE is not markdown file... skip it..."
	fi
}

function read_dir(){
	echo "[INFO] read_dir $1"
	FILE_LIST=`ls $1`
	for FILE in ${FILE_LIST}
	do
		if [ -f "$1/$FILE" ]
		then
			convert $1/${FILE}
		elif [ -d "$FILE" ]
		then
			read_dir $1/${FILE}
		fi
	done
}

read_dir $DIR
