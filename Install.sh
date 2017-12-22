#! /bin/bash

PluginList="DrinkWater"

function InstallCommon()
{
    local mainDir=$1

    mkdir -p ${mainDir}/Common
    cp Common/sendemail.py ${mainDir}/Common
    cp Common/Util.sh ${mainDir}/Common

    sed -i "s;MAIN_DIR;${mainDir};g" ${mainDir}/Common/Util.sh
}

function InstallDrinkWater()
{
    local mainDir=$1
    local drinkDir="$1/DrinkWater"

    # copy scripts
    mkdir -p ${drinkDir}
    cp DrinkWater/* ${drinkDir}
    sed -i "s;DRINK_WATER_DIR;${drinkDir};g" ${drinkDir}/*.cron
    sed -i "s;MAIN_DIR;${mainDir};g" ${drinkDir}/DrinkWater.sh

    # add cronjob
    mv ${drinkDir}/*.cron /etc/cron.d
    service crond reload
}

function InstallDict()
{
    local mainDir=$1
    local dictDir="$1/Dict"
    echo $dictDir

    # copy scripts and conf file
    mkdir -p ${dictDir}
    cp Dict/* ${dictDir}
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.conf
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.sh
    sed -i "s;DICT_PLUGIN_DIR;${dictDir};g" ${dictDir}/*.cron
    sed -i "s;MAIN_DIR;${mainDir};g" ${dictDir}/*.sh

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


