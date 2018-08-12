#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$1" ]; then
	echo "Usage $0 <csb ticket number>"
	exit 1
fi
ticket=$1
dataDir=$DIR/data
rawFile=$dataDir/$ticket.raw
curl 'https://www.stlouis-mo.gov/government/departments/public-safety/neighborhood-stabilization-office/citizens-service-bureau/index.cfm' \
     -H 'Content-Type: application/x-www-form-urlencoded' \
     --data "requestId=$ticket&findByrRequest=Find+Status" \
     --silent \
     --compressed > $rawFile

cat $rawFile | grep "request is not searchable" > /dev/null
notSearchableCode=$?
if [ $notSearchableCode -eq 0 ]; then
	echo "$ticket was not found"
	rm $rawFile
	exit 2
fi

tableFile=$dataDir/$ticket.table
cat $rawFile | grep -A 1000 "<table class='data" | grep -B 1000 -m 1 "</table>" > $tableFile
rm $rawFile

