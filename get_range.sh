#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$2" ]; then
	echo "Usage $0 <starting csb ticket number> <ticket count>"
	exit 1
fi

notFoundCount=0
for ticket in $(seq -f %1.0f $1 $(($1 + $2)) ); do
	if [ $notFoundCount -gt 10 ]; then
		echo "Too many tickets not found in a row. Stopping."
		break
	fi
	echo "Retrieving $ticket"
	$DIR/get_csb_status.sh $ticket
	ticketCode=$?
	if [ $ticketCode -ne 0 ]; then
		((notFoundCount++))
	else
		notFoundCount=0
	fi
done
