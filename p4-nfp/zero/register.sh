#!/bin/bash
## script que acessa um registrador chamado "latency" que guarda 
## esse timestamp e guarda em log.


valid=true
count=1

function main(){
    while [ $valid ] 
    do
       
	    n206="$(sudo /opt/netronome/p4/bin/rtecli -p 20206 registers get -r $1 -i 0)"
	    n207="$(sudo /opt/netronome/p4/bin/rtecli -p 20207 registers get -r $1 -i 0)"

        echo $n206 $n207
        #tmp206=${n206:4:2}
        #tmp207=${n207:12:2}
	    #endValueStr=${nPackets:12:2}
	    
        #t206=$(( 16#$tmp206 ))
        #t207=$(( 16#$tmp207 ))

    	#endValue=$(( 16#$endValueStr ))
    	#printf "$1:$2 - ${nPackets} $startValue -  $endValue \n"
    	#printf "$1: - ${n206} $t206 |  ${n207} $t207 \n"
#        sleep 1s

    	#if [ $count -eq 100 ] 
	    #then
		#    break
    	#fi
	    #((count++))
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
