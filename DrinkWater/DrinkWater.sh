#! /bin/bash

UTILPATH=/MAIN_DIR/Common/Util.sh

source ${UTILPATH}

content=`date +"%Y-%m-%d %H"`

SendEmail "Water Water Water!!!" "${content}"

