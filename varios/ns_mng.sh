#!/bin/bash

function dellns(){
    ip -all netns del
}

function create(){

#parameters
ifsrc=vf0_0
ifdst=vf0_1
mtu=1500


ip netns add nssrc
ip link set $ifsrc netns nssrc
ip netns exec nssrc ip link set dev $ifsrc up
ip netns exec nssrc ifconfig $ifsrc  mtu $mtu 10.1.1.2/24
		
ip netns add nsdst
ip link set $ifdst netns nsdst
ip netns exec nsdst ip link set dev $ifdst up
ip netns exec nsdst ifconfig $ifdst mtu $mtu 10.1.2.2/24
