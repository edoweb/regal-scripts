#! /bin/bash

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $scriptdir
source variables.conf
mysql -uproai -p$REGAL_PASSWORD -e"DELETE from proai.rcFailure;"
cd -
