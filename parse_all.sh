#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dataDir=$DIR/data
find $dataDir -maxdepth 1 -type f -exec basename {} \; | cut -d'.' -f1 > all_tickets.temp
while read ticket; do
	echo "parsing $ticket"
    # $DIR/parse_csb.sh $ticket
done <all_tickets.temp
