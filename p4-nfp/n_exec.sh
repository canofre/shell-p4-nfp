#!/bin/bash
PATH_MG=/opt/MoonGen
IP_DST=10.2.0.10
IT=100

CMD=$PATH_MG/examples/netronome-packetgen/packetgen.lua
OP="-tx 0 -rx 2 -it $IT --dst-ip $IP_DST --dst-ip-vary 0.0.0.0 " 
echo $PATH_MG/build/MoonGen $CMD $OP






