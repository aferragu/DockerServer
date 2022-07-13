#!/bin/bash
tc qdisc del dev eth0 root
tc qdisc add dev eth0 root handle 1: tbf rate 10mbit burst 5000 limit 12000
tc qdisc add dev eth0 parent 1:1 handle 10: netem delay 50ms loss 0.5%
