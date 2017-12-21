#! /bin/bash

function SendEmail()
{
    subject=$1
    content=$2
    python /MAIN_DIR/Common/sendemail.py "${subject}" "${content}"
}

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

#tput setab [1-7] # Set the background colour using ANSI escape
#tput setaf [1-7] # Set the foreground colour using ANSI escape

#0    black     COLOR_BLACK     0,0,0
#1    blue      COLOR_BLUE      0,0,1
#2    green     COLOR_GREEN     0,1,0
#3    yellow    COLOR_YELLOW    1,1,0
#4    red       COLOR_RED       1,0,0
#5    magenta   COLOR_MAGENTA   1,0,1
#6    cyan      COLOR_CYAN      0,1,1
#7    white     COLOR_WHITE     1,1,1

#tput sgr0    # Reset text format to the terminal's default
#tput bel     # Play a bell

function SetRedOut()
{
    tput setf 4
}

function SetBlueOut()
{
    tput setf 1
}

function SetGreenOut()
{
    tput setf 2
}

function ResetOut()
{
    tput sgr0
}

function RedOut()
{
    tput setf 1
    echo $*
    tput sgr0
}

function GreenOut()
{
    tput setf 2
    echo $*
    tput sgr0
}


