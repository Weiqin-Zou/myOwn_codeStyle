#!/bin/bash

resDir=$1
idx=$2 #the idx loop for a given start and end
cmitChgFile=$3
clientAccount=$4
mkdir -p $resDir
rm ${resDir}/${idx}_curlFailed.res

clientCnt=$(cat $clientAccount | wc -l)
total=$(cat $cmitChgFile | wc -l)
for cnt in `seq 1 $total`
do
    c=$(sed -n "$cnt p" $cmitChgFile)
    fn=$(echo "$c" | awk -F "邹" '{print $1}')
    prID=$(echo "$c" |  awk -F "邹" '{print $2}')
    sha=$(echo "$c" | awk -F "邹" '{print $3}')
    chgLine=$(echo "$c" | awk -F "邹" '{print $4}')
    fname=$(echo "$c" | awk -F "邹" '{print $5}')
    patch=$(echo "$c" | awk -F "邹" '{print $6}')

    clientNum=$((cnt%clientCnt + 1))
    client=$(sed -n "${clientNum}p" $clientAccount)

    prefix="https://raw.githubusercontent.com/"
    relaF=$(echo $fname | cut -f7- -d "/")
    furl=${prefix}${fn}"/"${relaF}"?"$client
    #https://raw.githubusercontent.com/guardianproject/ChatSecureAndroid/20ce719f40b9fb747c20f3bc95b11f5c85ae60ee/res/xml/account_settings.xml
    curl $furl -o ${resDir}/${idx}_after.java
    if [ $? -ne 0 ];then
        echo $fn邹$prID邹$sha邹"$chgLine"邹$fname邹"$patch" >> ${resDir}/${idx}_curlFailed.res
        continue
    fi
  
    python getB4chgFile.py ${resDir}/${idx}_after.java "$patch" >${resDir}/${idx}_b4.java
 
   repo=$(echo ${fn} | cut -f2 -d "/")
   shortSha=${sha:0:6}
   fbaseName=$(basename $fname)
   b4File="b4_"${repo}"_"${prID}"_"${shortSha}"_"${fbaseName}
   afterFile="after_"${repo}"_"${prID}"_"${shortSha}"_"${fbaseName}

   mv ${resDir}/${idx}_b4.java ${resDir}/${b4File}
   mv ${resDir}/${idx}_after.java ${resDir}/${afterFile}

done
