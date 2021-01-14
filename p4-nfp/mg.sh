#!/bin/bash
##
## R.Canofre - canofre@inf.ufsm.br
## Script para gernciar a execução dos exemplos do MoonGem 
##

# Define diretorio onde esta o MoonGen e o dpdk-devbind
PATH_MG=/opt/MoonGen
PATH_EX=$PATH_MG/build/MoonGen
PATH_USERTOOLS=$PATH_MG/libmoon/deps/dpdk/usertools

main() {
    case "$1" in
        1|pkt)
            packetgen $* ;;
        *)
            uso ;;
    esac
}

uso(){
    printf " Executa os scripts de exemplos do MoonGen\n "
    printf " USO $0 [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "\t 1|pkt	: 1 (tx) (rx) (IP) - executa packetgen da netronome \n"
}

# $1 - tx
# $2 - rx
# $3 - IP
packetgen(){
	$PATH_EX $PATH_MG/examples/netronome-packetgen/packetgen.lua \
		-tx $2 -rx $3 --dst-ip $4 --dst-ip-vary 0.0.0.0
}

main $*

