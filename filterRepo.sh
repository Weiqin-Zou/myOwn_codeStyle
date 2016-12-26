#!/bin/bash

startTime=$1
interval_s=$2
interval_e=$3

clientAccount=$4
clientCnt=$(cat $clientAccount | wc -l)

workspace=${startTime}
mkdir -p $workspace

function beginFilter(){

    start=$startTime
    end=$(python everyNhours.py $start $interval_e)    
    prefix="https://api.github.com/search/repositories?"
    timeRange=$start" .. "$end
    query="q=language:Java+created:\"$timeRange\""
    url=$prefix$query
    
}

beginFilter $startTime $interval_s $interval_e $clientAccount
