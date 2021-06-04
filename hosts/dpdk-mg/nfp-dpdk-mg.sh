#!/bin/bash
##
## R.Canofre - canofre@inf.ufsm.br
## Script to manage moongen startup ans assign interfaces to dpdk
##

# Defines the path to the moongen and usertools directory
PATH_MG=/opt/MoonGen
PATH_USERTOOLS=$PATH_MG/libmoon/deps/dpdk/usertools

main() {
    case "$1" in
        mi|moongen-init)
            moongenInit > /tmp/moongen.log
            ;;
        ms|moongen-status)
            echo -e "\e[01;31mHugepages status\e[00m"
            mount | grep huge
            echo ""
            service dpdk-mg status
            ;;
        hp|mount-hp)
            hpMount
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

printHelp(){
    printf " USO nfp-dpdk-mg.sh [opcoes]\n\n"
    printf " Opcoes:\n"
    printf "\t h                    : exibe opções e uso\n"
    printf "\t hp|mount-hugepages   : monta hugepagens 1G e /mnt/hugei\n"
    printf "\t mi|moongen-init      : incializa o moongen \n"
    printf "\t ms|moongen-status    : status de inicializacao do moongen \n"
    printf "\t ns|nic-status        : lista o status das NIC \n"
    printf "\t nu|nic-unbind IDT    : desarrega o driver de uma NIC \n"
    printf "\t nb|nic-bind IDT DRIVER : carrega um driver em uma NIC \n"
    printf "\t\t DRIVER: igb_uio - DPDK | nfp - Netronome \n"
}

## Lists information about interfaces
nicStatus(){
    $PATH_USERTOOLS/dpdk-devbind.py --status-dev net | cut -d: -f2,3   
}

nicUnbind(){
    if [ $# -lt 2 ]; then echo "USO: nu IDT";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py -u $2 
}

nicBind(){
    if [ $# -lt 3 ]; then echo "USO: nb IDT DRIVER ";  exit; fi
    $PATH_USERTOOLS/dpdk-devbind.py --bind=$3 $2
} 

# Initializes moongen and add the corret interfaces to dpdk
moongenInit(){
    $PATH_MG/build.sh
    # removes all interfaces from the dpdk
    idRemover=(`nicStatus | grep drv=igb_uio | cut -d" " -f1`)
    for((i=0;i<${#idRemover[*]};i++)); do
        echo "nicUnbind $i ${idRemover[$i]}" 
        nicUnbind $i ${idRemover[$i]}
    done
    # adds the Netronome interface to dpdk
    idAdd=`nicStatus | grep 4000 | cut -d" " -f1`
    echo "nicBind 0 $idAdd igb_uio"
    nicBind 0 $idAdd igb_uio

    hpMount
}

hpMount(){
    if [ `mount | grep huge | grep 1024 | wc -l` -eq 0 ]; then
        mount -t hugetlbfs none /mnt/huge/ -o pagesize=1G
    fi
}

main $* 
