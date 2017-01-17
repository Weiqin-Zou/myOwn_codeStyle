# -*- encoding:utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
import re
import traceback

def getBlock(patch_str):
    chgP=re.compile(r"@@ .*? @@")
    b4P=re.compile(r"^[-| ]")
    p=patch_str.replace("去","\n").split("\n")
    block={}
    endLineNum={}
    unit=''
    for pi in p:
        try:
            if chgP.search(pi):
                if unit!='':
                    block[start]=unit[:-1]
                unit=''
                f=pi.split()[2].split(",")
                (start,num)=(int(f[0]),int(f[1]))
                endLineNum[start]=start+num-1
                continue
            if b4P.search(pi):
                unit=unit+pi[1:]+'\n'
        except:
            traceback.print_exc()
    block[start]=unit[:-1]
    endLineNum[start]=start+num-1
    return block,endLineNum

def getB4file(after_fin,patch_str):
    (block,endLineNum)=getBlock(patch_str)
    lineNum=0
    start=0
    flag=0
    for line in after_fin.xreadlines():
        try:
            lineNum+=1
            line=line.strip('\n')
            if lineNum in block:
                flag=1
                print block[lineNum]
                start=lineNum
                continue
            if flag:
                if lineNum>start and lineNum<=endLineNum[start]:
                    continue
                else:
                    print line
                    flag=0
            else:
                print line
        except:
            traceback.print_exc()


if __name__ == "__main__":
    after_fin=sys.argv[1]
    patch=sys.argv[2]
    getB4file(file(after_fin,'r'),patch)
