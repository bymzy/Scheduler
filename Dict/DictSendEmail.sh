#! /bin/bash

UTILPATH=/MAIN_DIR/Common/Util.sh
DICTPLUGIN=/DICT_PLUGIN_DIR/DictPlugin.sh

source ${UTILPATH}
source ${DICTPLUGIN}

dateString=`date +"%Y-%m-%d %H:%M:%S"`
emailContent=`GetLastWords 10`
emailSubject="Daily English Words! ${dateString}"

SendEmail "${emailSubject}" "${emailContent}"

