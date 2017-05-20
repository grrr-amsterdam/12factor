#!/bin/sh
function loaddotenv {
    if [ -z "$1" ]; then
        local file='.env'
    else
        local file=$1    
    fi 

    if [ ! -f $file ]; then
        echo "[ERROR] Could not load $file"
        return 1
    fi

    echo "Processing $file"
    export $(cat $file | grep -v ^# | xargs)
}
