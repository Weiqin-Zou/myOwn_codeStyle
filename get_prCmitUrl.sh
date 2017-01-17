./exportMongDat.sh "127.0.0.1" 35repos pulls "fn,number,commits_url" 35repos_pr
./exportMongDat.sh "127.0.0.1" another75repos pulls "fn,number,commits_url" 40repos_pr
./exportMongDat.sh "127.0.0.1" another75repos pullcommits "fn,pn" 40repos_prcmit
./exportMongDat.sh "127.0.0.1" 35repos pullcommits "fn,pn" 35repos_prcmit
awk 'BEGIN{FS=",";OFS=","}{if(NR==FNR){arr[$1$2]=1}else{if(!($1$2 in arr)){print $0}}}' 35repos_prcmit 35repos_pr | sort -u > 35repos_prCmitUrl 
sed -i '$d' 35repos_prCmitUrl

awk 'BEGIN{FS=",";OFS=","}{if(NR==FNR){arr[$1$2]=1}else{if(!($1$2 in arr)){print $0}}}' 40repos_prcmit 40repos_pr | sort -u  > 40repos_prCmitUrl
sed -i '$d' 40repos_prCmitUrl
