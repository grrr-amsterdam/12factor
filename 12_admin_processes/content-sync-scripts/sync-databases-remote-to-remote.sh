#!/bin/sh

if [ ! -z "$1" ]; then
    source_ssh_user=$1
else
    echo "Please provide the SSH user for the content source as parameter 1."
    exit 1
fi

if [ ! -z "$2" ]; then
    source_ssh_host=$2
else
    echo "Please provide the SSH host for the content source as parameter 2."
    exit 1
fi

if [ ! -z "$3" ]; then
    source_db_user=$3
else
    echo "Please provide the database user for the content source as parameter 3."
    exit 1
fi

if [ ! -z "$4" ]; then
    source_db_name=$4
else
    echo "Please provide the database name for the content source as parameter 4."
    exit 1
fi

if [ ! -z "$5" ]; then
    source_db_host=$5
else
    echo "Please provide the database hostname for the content source as parameter 5."
    exit 1
fi

if [ ! -z "$SYNC_DB_SOURCE_PASSWORD" ]; then
    source_db_password=$SYNC_DB_SOURCE_PASSWORD
else
    echo "Please provide the database password for the content source,"
    echo "either as SYNC_DB_SOURCE_PASSWORD environment variable or interactively."
    printf "Source database password: "
    read source_db_password
fi

if [ ! -z "$6" ]; then
    destination_ssh_user=$6
else
    echo "Please provide the SSH user for the content destination as parameter 6."
    exit 1
fi

if [ ! -z "$7" ]; then
    destination_ssh_host=$7
else
    echo "Please provide the SSH host for the content destination as parameter 7."
    exit 1
fi

if [ ! -z "$8" ]; then
    destination_db_user=$8
else
    echo "Please provide the database user for the content destination as parameter 8."
    exit 1
fi

if [ ! -z "$9" ]; then
    destination_db_name=$9
else
    echo "Please provide the database name for the content destination as parameter 9."
    exit 1
fi

if [ ! -z "${10}" ]; then
    destination_db_host=${10}
else
    echo "Please provide the database host for the content destination as parameter 10."
    exit 1
fi

if [ ! -z "$SYNC_DB_DESTINATION_PASSWORD" ]; then
    destination_db_password=$SYNC_DB_DESTINATION_PASSWORD
else
    echo "Please provide the database password for the content destination,"
    echo "either as SYNC_DB_DESTINATION_PASSWORD environment variable or interactively."
    printf "Destination database password: "
    read destination_db_password
fi

dumpfile=.${source_db_name}_dump.sql

ssh $source_ssh_user@$source_ssh_host \
    mysqldump \
        -h $source_db_host \
        -u $source_db_user \
        -p$source_db_password \
        --databases $source_db_name \
        --result-file=$dumpfile &&
scp $source_ssh_user@$source_ssh_host:$dumpfile . &&
ssh $source_ssh_user@$source_ssh_host rm -f $dumpfile &&
ssh $destination_ssh_user@$destination_ssh_host \
    mysql \
        -h $destination_db_host \
        -u $destination_db_user \
        -p$destination_db_password \
        $destination_db_name < $dumpfile &&
rm -f $dumpfile
