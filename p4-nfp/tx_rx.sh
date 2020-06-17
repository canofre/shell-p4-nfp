#!/bin/bash
#cut -d":" -f4 | cut -d} -f1 | tr '\n' ' '
#cut -d":" -f4 | tr '},\n' ' '
P1=20206
P2=20207

while :; do

    txRx_p1=`rtecli -p $P1 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
    txRx_p2=`rtecli -p $P2 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
    printf "$P1 \t $txRx_p1 \t $P2 \t $txRx_p2 \n"
done

