#!/bin/bash
##
## R.Canofre - canofre@inf.ufsm.br
## Script to manage moongen startup ans assign interfaces to dpdk
##

# Defines the path to the moongen and usertools directory
PATH_MG=/opt/MoonGen
PATH_USERTOOLS=$PATH_MG/libmoon/deps/dpdk/usertools

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
    printf "\t nb|nic-bind IDT DRIVER : carrega um driver em uma NIC \n"
    printf "\t\t DRIVER: igb_uio - DPDK | nfp - Netronome \n"
}

## Lists information about interfaces
function nicStatus(){
    $PATH_USERTOOLS/dpdk-devbind.py --status-dev net | cut -d: -f2,3   
}

function nicUnbind(){
    if [ $# -lt 2 ]; then echo "USO: nu IDT";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py -u $2 
}

function nicBind(){
    if [ $# -lt 3 ]; then echo "USO: nb IDT DRIVER ";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py --bind=$3 $2
} 

# Initializes moongen and add the corret interfaces to dpdk
function moongenInit(){
    $PATH_MG/build.sh
    # removes all interfaces from the dpdk
    idRemover=`nicStatus | grep drv=igb_uio | cut -d" " -f1`
    for((i=0;i<${#idRemover[*]};i++)); do
        nicUnbind $i ${idRemover[$i]}
    done
    # adds the Netronome interface to dpdk
    idAdd=`nicStatus | grep 4000 | cut -d" " -f1`
    nicBind 0 $idAdd igb_uio
}

main $*
