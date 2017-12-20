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
    #local url=${DICTURL}${word}"&Samples=false";
    local url=${DICTURL}${word}

    curl ${url} 2>/dev/null
}

function QueryWord()
{
    local word=$1

    local res=`sqlite3 ${DBPATH} <<EOF
select * from ${DICTTABLE} where Name == "${word}";
EOF`
    echo ${res} | tr "_" " " | awk -F "|" '{print $4}' | base64 -d -i
}

function UpdateWord()
{
    local word=$1
    local lastTime=$2

    sqlite3 ${DBPATH} <<EOF
UPDATE ${DICTTABLE} SET LastTime = ${lastTime} WHERE Name = "${word}";
EOF
}

function GetLastWords()
{
    local count=$1

    sqlite3 ${DBPATH} <<EOF
SELECT Trans from ${DICTTABLE} ORDER BY LastTime DESC LIMIT ${count};
EOF
}

function ShellFormatWords()
{
    local json=$1

    SetGreenOut
    #output "Word"
    echo ${json} | jq -r "(\"Word: \" +  .word)"
    echo ""


    SetBlueOut
    #output pronunciation
    echo ${json} | jq -r ".pronunciation | (\"AmE: \" + .AmE + \"    BrE: \" + .BrE)"
    echo ""

    #output defs
    echo ${json} | jq -r ".defs | .[ ] | (.pos + \"  ==> \" + .def)"
    echo ""

    SetRedOut
    #output samples
    echo ${json} | jq -r ".sams | .[0:5] | .[] | .eng ,.chn, \" \""

    ResetOut
}


