#!/bin/bash

fnList=$1
clientAccount=$2
clientCnt=$(cat $clientAccount | wc -l)
contriLimit=10 #contributors number >=10

cnt=1
rm failed developerOk_fn
for fn in $(cat $fnList)
do
    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)
    fnUrl="https://github.com/${fn}?${client}"
  
    rm fntmp
    curl -m 120 $fnUrl -o fntmp
    contriCnt=$(grep -B2 "^ *contributors$" fntmp | head -1 | awk '{print $NF}')
    if [ "$contriCnt" = "" ];then
        echo "$fn:curl contributors failed" >>failed
        continue
    fi

    if [ $contriCnt -ge $contriLimit ];then
        collaUrl="https://github.com/${fn}/issues/show_menu_content?partial=issues/filters/authors_content"
        rm collatmp
        curl -m 120 $collaUrl -o collatmp
        collaCnt=$(grep "\"select-menu-item-text\"" collatmp | wc -l)
        if [ "$collaCnt" = "" ];then
            echo "$fn:curl collaborators failed" >>failed
            continue
        fi
        #half=$(echo $contriCnt | bc  ) TODO!!!
        if [ $colla -le $half ];then
            echo $fn $cldPrCnt $cldIssueCnt >> developerOk_fn
        fi
    fi
    cnt=$((cnt+1))
done
