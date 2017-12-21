#! /bin/bash

source ./sch.conf

function InstallCommon()
{
    local mainDir=$1
    mkdir -p ${mainDir}

    cp sendemail.py ${mainDir}
    cp Util.sh ${mainDir}
    cp sch.conf ${mainDir}

    sed -i "s;MAIN_DIR;${mainDir};g" ${mainDir}/sch.conf
    sed -i "s;MAIN_DIR;${mainDir};g" ${mainDir}/Util.sh
}

function InstallDict()
{
    local dictDir="$1/Dict"
    echo $dictDir

    # copy scripts and conf file
    mkdir -p ${dictDir}
    cp Dict/* ${dictDir}
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.conf
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.sh
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.cron

    # add alias
    echo "alias sw=\"sh ${dictDir}/SaveWord.sh\"" >>/root/.bashrc

    # add cronjob
    mv ${dictDir}/dict.cron /etc/cron.d
    service crond reload
}

installDir=$1

InstallCommon ${installDir}

for plugin in "${PluginList}"
do
    Install${plugin} ${installDir}
done


