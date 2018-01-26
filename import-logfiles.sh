#! /bin/bash

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $scriptdir
source variables.conf

YESTERDAY=$(date +"%d/%b/%Y" -d"yesterday")    
TMP=$REGAL_TMP
IDSITE=4
STATS_LOG=$REGAL_LOGS/stats.log

function loadLogFile() {
    PATTERN=$1
    zgrep --no-filename $PATTERN $APACHE_LOG/$APACHE_ACCESS_LOGNAME.*|sort|uniq > $TMP/matomoImport.log
    python $MATOMO/misc/log-analytics/import_logs.py --recorder-max-payload-size=200 --url $MATOMO_URL --login $MATOMO_ADMIN --password $MATOMO_PASSWORD $TMP/matomoImport.log --idsite=$IDSITE >> $STATS_LOG
}

loadLogFile "$YESTERDAY"

cd -
# Beispiel um die Logfiles der letzten 24 Tage zu laden
#
#for i in {1..24};do echo loadLogFile "$(date +"%d/%b/%Y" -d"$i days ago")";done

