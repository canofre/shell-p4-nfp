#!/bin/bash
# Lista todas as interfaces
function showInterfaces (){
	ip link
}

function idt(){
	DEVICE=$1
	ethtool -W ${DEVICE} 0
	DEBUG=$(ethtool -w ${DEVICE} data /dev/stdout | strings)
	SERIAL=$(echo "${DEBUG}" | grep "^SN:")
	ASSY=$(echo ${SERIAL} | grep -oE AMDA[0-9]{4})
	
	echo ""	
	echo "Interface :" $DEVICE ${SERIAL} 
	
	ip link | grep -A 1 $DEVICE
	echo "-------------"
}

PCIA=$(lspci -d 19ee:4000 | awk '{print $1}' | xargs -Iz echo 0000:z)
INTERFACES=`echo $PCIA | tr ' ' '\n' | xargs -Iz echo "ls /sys/bus/pci/devices/z/net" | bash`

DEVICE=`echo $INTERFACES | cut -d" " -f1`
echo $DEVICE
idt $DEVICE

DEVICE=`echo $INTERFACES | cut -d" " -f2`

idt $DEVICE

