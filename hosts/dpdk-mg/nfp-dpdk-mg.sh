#!/bin/bash
##
## R.Canofre - canofre@inf.ufsm.br
## Script para gernciar a inicializacao do ambiente, carregando o MoonGem 
## e atribuindo a interface ao DPDK
##

# Define diretorio onde esta o MoonGen e o dpdk-devbind
PATH_MG=/opt/MoonGen
PATH_USERTOOLS=$PATH_MG/libmoon/deps/dpdk/usertools
DPDK_DRIVER=igb_uio

# Inicializa a interface e seu driver de kernet
declare -A NFP=( [idt]=03:00.0 [driver]=nfp ) #enp8s0np...
declare -A PCI=( [idt]=04:00.0 [driver]=r8169 ) #enp6s0

function main() {
    case "$1" in
        mi|moongen-init)
            moongenInit 
            ;;
        ns|nic-status)
            nicStatus $*
            ;;
        nu|nic-unbind)
            nicUnbind $*
            ;;
        nb|nic-bind)
            nicBind $*
            ;;
        *)
            printHelp
            ;;
    esac
}

function printHelp(){
    printf " USO nfp-dpdk-mg.sh [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "\t h                      : exibe opções e uso\n"
    printf "\t mi|moongen-init        : incializa o moongen \n"
    printf "\t ns|nic-status          : lista o status das NIC \n"
    printf "\t nu|nic-unbind IDT      : desarrega o driver de uma NIC \n"
    printf "\t nb|nic-bind DRIVER IDT : carrega um driver em uma NIC \n"
    printf "\t\t DRIVER: igb_uio - DPDK | nfp - Netronome \n"
}

## Lista as informações das interfaces
## [IDT da placa] 'Descricao' [if=..] drv=em_uso unused=nao_usado
function nicStatus(){
    $PATH_USERTOOLS/dpdk-devbind.py --status-dev net | cut -d: -f2,3   
}

function nicUnbind(){
    if [ $# -lt 2 ]; then echo "USO: nu IDT";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py -u $2 
}

function nicBind(){
    if [ $# -lt 3 ]; then echo "USO: nb DRIVER IDT";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py --bind=$2 $3
} 

# Carrega o MoonGen 
function moongenInit(){
	$PATH_MG/build.sh
}

main $*
