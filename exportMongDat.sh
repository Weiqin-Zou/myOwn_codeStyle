#!/bin/bash
ip=$1
db=$2
col=$3
field=$4
out=$5

#mongoexport -h "127.0.0.1" -d onlyTest -c pullcommits --type=csv -o ttpr -f fn,pn

mongoexport -h $ip -d $db -c $col --type=csv -o $out -f $field

