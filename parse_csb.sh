#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$1" ]; then
	echo "Usage $0 <csb ticket number>"
	exit 1
fi
ticket=$1
dataDir=$DIR/data
tableFile=$dataDir/$ticket.table
csvFile=$dataDir/$ticket.csv
echo -n  $ticket > $csvFile
while read headerLine; do
	dataLine=$(cat $tableFile \
		   | grep -A 100 "$headerLine" \
		   | grep -B 100 -m 1 "</td>" \
		   | grep -A 100 "<td" \
		   | tr '\n' ' ' \
		   | sed -e 's/<td >/<td>/' \
		   | sed -e 's/"//g' \
		   | sed -e 's/<td>\(.*\)<\/td>/\1/' \
		   | sed -e 's/^[[:space:]]*//' \
		   | sed -e 's/[[:space:]]*$//')
	
	echo -n ",\"$dataLine\"" >> $csvFile
done <$DIR/status_headers
echo "" >> $csvFile
