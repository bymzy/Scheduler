#! /bin/bash

DICTPLUGIN=/DICT_PLUGIN_DIR/DictPlugin.sh

source ${DICTPLUGIN}

function SaveWord()
{
    if [ $# -ne 1 ]
    then
        echo "you should input one word!"
        exit 
    fi

    Word=$1

    CheckDepend

    CreateDictTable

    queryRes=`QueryWord "$Word"`

    echo ${queryRes} | grep "An error occurs"
    if [ $? -eq 0 ]
    then
        echo "Query word from bing failed.Abort!"
        exit 1
    fi

    insertTime=`GetPosixTime`

    if [ ! -z "$queryRes" ]
    then
        UpdateWord "${Word}" ${insertTime}
        ShellFormatWords "${queryRes}"
    else
        trans=`TranslateWord "$Word"`
        base64Trans=`echo -n "${trans}" | base64 2>&1 | tr "\n" "_"`
        InsertWordToDictTalbe "$Word" $insertTime "${base64Trans}"
        ShellFormatWords "${trans}"
    fi

}

SaveWord $*

