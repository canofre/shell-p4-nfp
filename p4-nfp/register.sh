#!/bin/bash
## script que acessa um registrador chamado "latency" que guarda 
## esse timestamp e guarda em log.


valid=true
count=1

function main(){
    while [ $valid ] 
    do
       
	    nPackets="$(sudo /opt/netronome/p4/bin/rtecli -p $1 registers get -r $2 -i 0)"
    

        startValueStr=${nPackets:4:2}
	    endValueStr=${nPackets:12:2}
	    
        startValue=$(( 16#$startValueStr ))
    	endValue=$(( 16#$endValueStr ))
    	printf "$1:$2 - ${nPackets} $startValue -  $endValue \n"
        sleep 1s

    	if [ $count -eq 100 ] 
	    then
		    break
    	fi
	    ((count++))
    done
}
function ver(){
    startValueStr=${nPackets:12:8}
	endValueStr=${nPackets:34:8}
	
	startValue=$(( 16#$startValueStr ))
	endValue=$(( 16#$endValueStr ))

	latency=$[endValue-startValue]
	latencyVector[$count]=$latency
	#echo "${latency}"
	

    for i in "${latencyVector[@]}"
    do
    	#echo ${latencyVector[@]} > latency.dat 
	    echo $i >> latency.dat
    done
}

main $*
