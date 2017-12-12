#! /bin/bash


function GetPosixTime()
{
    echo `date +%s`
}

function CheckComponentExists()
{
    local component=$1

    which ${component} >/dev/null 2>&1
    if [ $? -ne 0 ]
    then
        echo "No ${component} exists in this machine!"
        exit 1
    fi
}


