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
    source_ssh_path=$3
else
    echo "Please provide the SSH path for the content source as parameter 3."
    echo "This should end with a trailing slash, and for a Capistrano / Bedrock setup,"
    echo "it should end with /shared/web/"
    exit 1
fi

if [ ! -z "$4" ]; then
    destination_s3_bucket=$4
else
    echo "Please provide the Amazon S3 bucket for the content destination as parameter 4."
    exit 1
fi

if [ ! -z "$5" ]; then
    destination_aws_profile=$5
else
    echo "Please provide the Amazon AWS profile for the content destination as parameter 5."
    echo "The aws-cli client expects this information in ~/.aws/config by default."
    exit 1
fi

temp_dir=.tmp_uploads

[ ! -d $temp_dir ] && mkdir $temp_dir
rsync -avz -u \
    $source_ssh_user@$source_ssh_host:$source_ssh_path \
    $temp_dir --progress &&
aws s3 sync $temp_dir/ s3://$destination_s3_bucket \
    --profile=$destination_aws_profile \
    --acl public-read &&
rm -rf $temp_dir
