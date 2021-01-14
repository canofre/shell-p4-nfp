#!/bin/bash
##
## R.Canofre - canofre@inf.ufsm.br
## Script para gernciar a inicializacao do ambiente, carregando o MoonGem 
## e atribuindo a interface ao DPDK
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
    printf " USO $0 [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "\t 1|pkt	: 1 (tx) (rx) (IP) - executa packetgen da netronome \n"
}

packetgen(){
	$PATH_EX $PATH_MG/examples/netronome-packetgen/packetgen.lua \
		-tx $2 -rx $3 --dst-ip $4 --dst-ip-vary 0.0.0.0
}

main $*

