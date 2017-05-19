#!/bin/sh
function loaddotenv {
    echo "Processing .env"
    export $(cat .env | grep -v ^# | xargs)
}
