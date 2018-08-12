#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dataDir=$DIR/data
nextTicket=$(ls -1 $dataDir | grep .table | tail -n 1 | cut -d'.' -f1)
notFoundCount=0
while [ $notFoundCount -lt 10 ]; do
  ((nextTicket++))
	echo "Retrieving $nextTicket"
	$DIR/get_csb_status.sh $nextTicket
	ticketCode=$?
	if [ $ticketCode -ne 0 ]; then
		((notFoundCount++))
	else
		notFoundCount=0
		$DIR/parse_csb.sh $nextTicket
	fi
done
echo "Update complete"