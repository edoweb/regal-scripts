#! /bin/bash                                                                                                                               

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $scriptdir
source variables.conf

SERVERPREFIX="$FRONTEND/resource"

curl -s -XGET $ELASTICSEARCH/${INDEXNAME}2/journal,monograph,webpage/_search -d'{"query":{"match_all":{}},"fields":["/@id"],"size":"50000"}'|\
egrep -o "$INDEXNAME:[^\"]*">$REGAL_HOME/logs/titleObjects.txt

for i in `cat $REGAL_HOME/logs/titleObjects.txt|sort`
do

ht=`curl -s $ELASTICSEARCH/${INDEXNAME}2/_all/$i | egrep -o "hbzId\":[\[\"]{1,2}[^\"]*"|egrep  -o "[A-Z]{2}[0-9]{9}"`;
doi=`curl -s $ELASTICSEARCH/${INDEXNAME}2/_all/$i | egrep -o "doi\":[\[\"]{1,2}[^\"]*"|egrep -o "10.*"|uniq`;
urn=`curl -s $ELASTICSEARCH/${INDEXNAME}2/_all/$i | egrep -o "urn\":[\[\"]{1,2}[^\"]*"|egrep -o "urn:[^\"]*"`;


if [ ${#ht} -eq 11 ]
then
    echo $ht, $SERVERPREFIX/$i , $doi, $urn
#else                                                                                                                                      
    # Do nothing - Verbund interessiert sich nur für Objekte mit HT                                                                        
    #echo $i , XXXXXXXXXXX;                                                                                                                
fi

done |sort > $REGAL_HOME/logs/pid-catalog-conc-`date +"%Y%m%d"`-all.csv

