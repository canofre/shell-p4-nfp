#!/bin/bash
#cut -d":" -f4 | cut -d} -f1 | tr '\n' ' '
#cut -d":" -f4 | tr '},\n' ' '
P1=20206
P2=20207

function txRx(){
    printf "$P1 \t\t TX \t RX \t | $P2 \t TX \t Rx \n"
    while :; do
        txRx_p1=`rtecli -p $P1 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
        txRx_p2=`rtecli -p $P2 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
        printf "$P1 \t $txRx_p1 \t $P2 \t $txRx_p2 \n"
        sleep 2
    done
}

function drop(){
    while :; do
        drop206=`rtecli -p $P1 counters list-system | grep DROP_META | cut -d":" -f4- | cut -d"}" -f1`
        drop207=`rtecli -p $P2 counters list-system | grep DROP_META | cut -d":" -f4- | cut -d"}" -f1`
        printf "DROP_META - $P1:\t$drop206 \t | $P2: \t$drop207\n"
        sleep 2    
    done
}


txRx
#drop
