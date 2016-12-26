import sys
import datetime

'''python every12hours.py '2012-12-12T12:23:34Z' 12'''
'''add N hours to an existing timestamp and return the added timestamp'''
def addedNhours(startTime, interval):
    dayHours=24
    delta=int(interval)*1.0/dayHours
    endTime=(datetime.datetime.strptime(startTime, '%Y-%m-%dT%H:%M:%SZ')+datetime.timedelta(days=delta)).strftime('%Y-%m-%dT%H:%M:%SZ')
    print endTime
if __name__ == '__main__':
    start=sys.argv[1]
    inter=sys.argv[2]
    addedNhours(start,inter)
