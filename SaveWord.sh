#! /bin/bash

SCHCONF=/root/work/Scheduler/sch.conf
DICTCONF=/root/work/Scheduler/dict.conf
UTILPATH=/root/work/Scheduler/Util.sh

source ${SCHCONF}
source ${DICTCONF}
source ${UTILPATH}


function CheckDepend()
{
    CheckComponentExists curl
    CheckComponentExists sqlite3
    CheckComponentExists jq 
}

function CreateDictTable()
{
    sqlite3 ${DBPATH} <<EOF
CREATE TABLE IF NOT EXISTS ${DICTTABLE} (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name VARCHAR(25) NOT NULL UNIQUE,
    LastTime INTEGER NOT NULL,
    Trans TEXT
);
EOF
}

function InsertWordToDictTalbe()
{
    local word=$1
    local time=$2
    local trans=$3

    sqlite3 ${DBPATH} <<EOF
INSERT INTO ${DICTTABLE} (Name, LastTime, Trans)
VALUES ("${word}", ${time}, "${trans}");
EOF
    return $?
}

function TranslateWord()
{
    local word=`echo $1 | tr " " "+"`
    local url=${DICTURL}${word}"&Samples=false";

    curl ${url} 2>/dev/null
}

function QueryWord()
{
    local word=$1

    local res=`sqlite3 ${DBPATH} <<EOF
select * from ${DICTTABLE} where Name == "${word}";
EOF`
    echo ${res} | tr "\n" " " | awk -F "|" '{print $4}' | base64 -d -i
}

echo $#

if [ $# -ne 1 ]
then
    echo "you should input one word!"
    exit 
fi


Word=$1

CheckDepend

CreateDictTable

queryRes=`QueryWord "$Word"`

echo ${#queryRes} | grep "An error occurs"
if [ $? -eq 0 ]
then
    echo "Query word from bing failed.Abort!"
    exit 1
fi

if [ ! -z "$queryRes" ]
then
    echo $queryRes | jq .
    exit 0
fi

insertTime=`GetPosixTime`
trans=`TranslateWord "$Word"`
base64Trans=`echo -n "${trans}" | base64`

InsertWordToDictTalbe "$Word" $insertTime "${base64Trans}"

echo $trans | jq .





