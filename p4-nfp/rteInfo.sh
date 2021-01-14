#!/bin/bash
#cut -d":" -f4 | cut -d} -f1 | tr '\n' ' '
#cut -d":" -f4 | tr '},\n' ' '
PORTAS=( `nfp-config.sh ns | grep STATUS | cut -d" " -f3` )
echo ${PORTAS[0]}

txRx()
    printf "$P1 \t\t TX \t RX \t | $P2 \t TX \t Rx \n"
    while :; do
        txRx_p1=`rtecli -p $P1 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
        txRx_p2=`rtecli -p $P2 counters list-system | grep -e "'id': 35," -e "'id': 44," | cut -d":" -f4 | tr '},\n' ' '` 
        printf "$P1 \t $txRx_p1 \t $P2 \t $txRx_p2 \n"
        sleep 2
    done
}

drop(){
    while :; do
        drop206=`rtecli -p $P1 counters list-system | grep DROP_META | cut -d":" -f4- | cut -d"}" -f1`
        drop207=`rtecli -p $P2 counters list-system | grep DROP_META | cut -d":" -f4- | cut -d"}" -f1`
        printf "DROP_META - $P1:\t$drop206 \t | $P2: \t$drop207\n"
        sleep 2    
    done
}

# Recebe a porta ($1) e o nome do contador($2) que vai ser procurado
contadorSistema(){
    while :; do
        printf "\nDROP_META - $1:\t"
        rtecli -p $1 counters list-system | grep $2 | cut -d":" -f4- | cut -d"}" -f1
    done
}


contadorSistema ${PORTAS[0]} $1
