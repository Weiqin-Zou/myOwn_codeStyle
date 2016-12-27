#!/bin/bash

startDate=$1
endDate=$2
whichHour=$3
clientAccount=$4
clientCnt=$(cat $clientAccount | wc -l)
interval_s=12 #12 hours
interval_e=1 #1 hour
prefix="https://api.github.com/search/repositories?"
query="q=language:Java+created:"
pageLimit=100



#one_search $startTime $endTime
function one_search(){
    start=$1
    end=$2
    timeRange=$start".."$end

    gotFn=0
    cnt=1
    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)
    pageCnt=1
  url=${prefix}${query}"\"${timeRange}\"&page=${pageCnt}&per_page=${pageLimit}&${client}"
    curl -m 120 $url -o ${whichHour}/tmpFilter

    grep "\"full_name\":" ${whichHour}/tmpFilter | awk '{print $NF}' | cut -f1 -d "," > ${whichHour}/tmpFilterFn
    totalCnt=$(grep "\"total_count\":" ${whichHour}/tmpFilter | awk '{print $NF}' | cut -f1 -d ",")
    echo $timeRange $totalCnt >> ${whichHour}/${whichHour}_totalCnt
    cat ${whichHour}/tmpFilterFn >>${whichHour}/${whichHour}_fn
    fnCnt=$(cat ${whichHour}/tmpFilterFn | wc -l)
    gotFn=$((gotFn+fnCnt))

    rm ${whichHour}/tmpFilter
    if [ "$gotFn" -eq "$totalCnt" ];then
        return
    fi

    while [ "$gotFn" -lt "$totalCnt" ]
    do
        pageCnt=$((pageCnt+1))
        cnt=$((cnt+1))
        clientNum=$((cnt%clientCnt + 1))
        client=$(sed -n "${clientNum}p" $clientAccount)
url=${prefix}${query}"\"${timeRange}\"&page=${pageCnt}&per_page=${pageLimit}&${client}"

        curl -m 120 $url -o ${whichHour}/tmpFilter

        grep "\"full_name\":" ${whichHour}/tmpFilter | awk '{print $NF}' | cut -f1 -d "," > ${whichHour}/tmpFilterFn
        fnCnt=$(cat ${whichHour}/tmpFilterFn | wc -l)
        gotFn=$((gotFn+fnCnt))
        cat ${whichHour}/tmpFilterFn >>${whichHour}/${whichHour}_fn
        rm ${whichHour}/tmpFilter
    done
}

#example run_filter $startDate $stopDate
function run_filter(){
    mkdir -p $whichHour 
    rm ${whichHour}/${whichHour}_fn
    rm ${whichHour}/${whichHour}_totalCnt
    startTime=$startDate"T"$whichHour":00:00Z"
    stopTime=$endDate"T00:00:00Z"
    if [ "$startTime" \> "$stopTime" ];then
        return
    fi
    endTime=$(python everyNhours.py $startTime $interval_e)
    if [ "$endTime" \> "$stopTime" ];then
        endTime=$stopTime
    fi
    one_search $startTime $endTime
    startTime=$(python everyNhours.py $startTime $interval_s)
    while [ "$startTime" \< "$stopTime" ]
    do
        endTime=$(python everyNhours.py $startTime $interval_e)
        if [ "$endTime" \> "$stopTime" ];then
            endTime=$stopTime
        fi
        one_search $startTime $endTime 
        startTime=$(python everyNhours.py $startTime $interval_s)

    done
}
run_filter $startDate $endDate
