#!/bin/bash
##
## Script para manupilar o driver utilizado pelas interfaces de rede
## alterando entre o uso pelo dpdk e pelo driver disponibilizado pelo
## kernel.
##

DIR_MG=/opt/MoonGen
DIR_TOOLS=$DIR_MG/libmoon/deps/dpdk/usertools

## Lista as informações das interfaces
## [IDT da placa] 'Descricao' [if=..] drv=em_uso unused=nao_usado
function iface_status(){
    $DIR_TOOLS/dpdk-devbind.py --status-dev net | cut -d: -f2,3   
}


## Altera a utilizacao da placa cujo IDT foi passado como paremetro.
function altera_drv(){
    linha=`iface_status | grep $1 | cut -d"'" -f3`
    if [[ "$linha" == *"Active"* ]]; then
        echo "Interace em uso nao pode ser alterada"
        exit
    fi
    # interface sem definicao
    if [[ "$linha" != *"drv="* ]]; then
        drv=`echo $linha | cut -d'=' -f2 | cut -d',' -f1`
    # interface com driver do kernel ou com if=' '
    elif [[ "$linha" == *"if="* ]]; then
        drv=`echo $linha | cut -d' ' -f3 | cut -d'=' -f2`
    # interface em uso pelo dpdk
    else 
        drv=`echo $linha | cut -d' ' -f2 | cut -d'=' -f2`
    fi
    
    $DIR_TOOLS/dpdk-devbind.py --bind=$drv $1 

}

## Altera o drv de todas as interafaces que nao estejam ativas
function altera_todas(){
    interfaces=`iface_status | grep "unused" | grep -v "Active" | cut -d' ' -f1`
    for iface in $interfaces
    do
        echo "    Alterando $iface"
        altera_drv $iface
    done
}

function main(){
    if [ $# -eq 0 ]; then 
        iface_status
    
        echo -e "\t \e[32;1m iface_dpdk.sh [IDT] \tAletera o driver da interface [IDT] \e[m"
        echo -e "\t \e[32;1m iface_dpdk.sh all \tAletera o driver de todas as interface
\e[m"
        exit
    elif [ "$1" == "t" ]; then
        altera_todas
    else
        altera_drv $*
    fi
    
    iface_status
}


 
main $*
