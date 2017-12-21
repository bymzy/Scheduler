#! /bin/bash

UTILPATH=/DICT_PLUGIN_DIR/../Util.sh
DICTPLUGIN=/DICT_PLUGIN_DIR/DictPlugin.sh

source ${UTILPATH}
source ${DICTPLUGIN}

dateString=`date +"%Y-%m-%d %H:%M:%S"`
email=`GetLastWords 10`
emailSubject="Daily English Words!"
emailContent="${dateString} Today's English words"

SendEmail "${emailSubject}" "${emailContent}"

