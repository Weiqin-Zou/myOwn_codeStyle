#!/bin/bash

start="2014-11-24"
end="2016-01-01"

for hour in "00" "01" "02" "03" "04" "05" "06" "08" "09" "10" "11" "07"
do
    ./filterRepo.sh $start $end $hour 12client_secret > ${hour}.log 2>&1
done
