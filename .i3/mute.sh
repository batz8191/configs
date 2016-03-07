#!/bin/bash
FILE=/tmp/vol
VOL=`amixer sget Master | perl -ne 'm/(\d+) \[\d+%\]/ && print $1'`
if [[ $VOL -gt 0 ]]; then
	echo $VOL > $FILE
	amixer sset Master 0 > /dev/null
else
	if [ -r $FILE ]; then
		foo="`cat $FILE`"
		amixer sset Master $foo > /dev/null
	else
		amixer sset Master 0 > /dev/null
	fi
fi
