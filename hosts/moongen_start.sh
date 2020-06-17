#!/bin/bash
# Define diretorio onde esta o MoonGen e o dpdk-devbind
DIR_MG=/opt/MoonGen
DIR_TOOLS=$DIR_MG/libmoon/deps/dpdk/usertools
DATE=`date +%H%M`
LOG=/var/log/moongen_start_$DATE.log
touch $LOG
# Chama o build do moogen
$DIR_MG/build.sh 


# Define a interface e seu driver de kernet
declare -A NFP_10G=( [idt]=08:00.0 [driver]=nfp )   #enp8s0np...
declare -A NFP_40G=( [idt]=41:00.0 [driver]=nfp )   #enp65s0np...
declare -A WIFI=( [idt]=05:00.0 [driver]=iwlwifi )  #wlo2
declare -A GIGA=( [idt]=06:00.0 [driver]=igb )      #enp6s0

# driver a ser definido para passar interfaace para DPDK
DRIVE_DPDK=igb_uio

# Altera as interafaces
$DIR_TOOLS/dpdk-devbind.py --bind=${WIFI[driver]} ${WIFI[idt]} 
$DIR_TOOLS/dpdk-devbind.py --bind=${GIGA[driver]} ${GIGA[idt]}
$DIR_TOOLS/dpdk-devbind.py --bind=${NFP_10G[driver]} ${NFP_10G[idt]} 
#$DIR_TOOLS/dpdk-devbind.py --bind=${NFP_40G[driver]} $DRIVER_DPDK

