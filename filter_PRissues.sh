#!/bin/bash

fnList=$1
clientAccount=$2
clientCnt=$(cat $clientAccount | wc -l)
prLimit=200 #closed PR number >=200
issueLimit=20 #closed issues number >=20

cnt=1
rm failed prIssueOk_fn
for fn in $(cat $fnList)
do
    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)
    issueUrl="https://api.github.com/search/issues?q=type:issue+repo:${fn}+state:closed&${client}"
    prUrl="https://api.github.com/search/issues?q=type:pr+repo:${fn}+state:closed&${client}"

    rm prtmp
    curl -m 120 $prUrl -o prtmp
    cldPrCnt=$(grep "\"total_count\":" prtmp | awk '{print $NF}' | cut -f1 -d ",")
    if [ "$cldPrCnt" = "" ];then
        echo "$fn:curl prs failed" >>failed
        continue
    fi

    if [ $cldPrCnt -ge $prLimit ];then
        rm issuetmp
        curl -m 120 $issueUrl -o issuetmp
        cldIssueCnt=$(grep "\"total_count\":" issuetmp | awk '{print $NF}' | cut -f1 -d ",")
        if [ "$cldIssueCnt" = "" ];then
            echo "$fn:curl issues failed" >>failed
            continue
        fi
        echo $fn >> prIssueOk_fn
    fi
    cnt=$((cnt+1))
done
