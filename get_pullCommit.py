# -*- encoding:utf-8 -*-
import io
import sys
import traceback
reload(sys)
sys.setdefaultencoding('utf-8')
import os
import json
import re
from pymongo import *

def get_prcmit_file(db,chgFile_fout):
    lineP=re.compile(r"@@ .*? @@")
    javaP=re.compile(r"\.java$")
    unit=100000 #every 10w change file record into a single file
    cnt=0
    for cmit in db.pullcommits.find({}):
        try:
            repoName=cmit["fn"]
            prID=str(cmit["pn"])
            sha=cmit["sha"]
            chgF=cmit["files"]
            for f in chgF:
                try:
                    rawUrl=f["raw_url"]
                    if javaP.search(rawUrl):
                        p=f["patch"]
                        chgLine=str(lineP.findall(p))
                        p=p.replace("\n","去")
                        chgRes=(repoName,prID,sha,chgLine,rawUrl,p)
                        chgRes="邹".join(chgRes)
                        cnt+=1
                        num=cnt/(unit)
                        out=chgFile_fout+"_"+str(num)
                        print>>file(out,"a"), chgRes
                except:
                    traceback.print_exc()
                    continue
        except:
            traceback.print_exc()
            continue

if __name__ == '__main__':
    try:
        ip=sys.argv[1]
        client=MongoClient(ip,27017)
        dbName=sys.argv[2]
        chgFile_fout=sys.argv[3]
        db=client[dbName]
        get_prcmit_file(db, chgFile_fout)
        client.close()
    except:
        traceback.print_exc()
