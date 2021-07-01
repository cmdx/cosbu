#!/bin/bash
# source bucket info
SRC_ACCESSKEY=${COSBU_SRC_ACCESSKEY}
SRC_SECRETKEY=${COSBU_SRC_SECRETKEY}
SRC_ENDPOINT=${COSBU_SRC_ENDPOINT}
SRC_BUCKET=${COSBU_SRC_BUCKET}
# target bucket info
TGT_ACCESSKEY=${COSBU_TGT_ACCESSKEY}
TGT_SECRETKEY=${COSBU_TGT_SECRETKEY}
TGT_ENDPOINT=${COSBU_TGT_ENDPOINT}
TGT_BUCKET=${COSBU_TGT_BUCKET}
# constants for rclone on IBM COS
TYPE=s3
PROV==IBMCOS
AUTH=env_auth=false

setupS3() {
    echo "1. Setting up rclone config parameters"
    echo [COS_SOURCE] > /tmp/.rclone.conf
    echo type=s3 >> /tmp/.rclone.conf
    echo provider=IBMCOS >> /tmp/.rclone.conf
    echo env_auth=false >> /tmp/.rclone.conf
    echo access_key_id=${SRC_ACCESSKEY} >> /tmp/.rclone.conf
    echo secret_access_key=${SRC_SECRETKEY} >> /tmp/.rclone.conf
    echo endpoint=${SRC_ENDPOINT} >> /tmp/.rclone.conf

    echo [COS_TARGET] >> /tmp/.rclone.conf
    echo type=s3 >> /tmp/.rclone.conf
    echo provider=IBMCOS >> /tmp/.rclone.conf
    echo env_auth=false >> /tmp/.rclone.conf
    echo access_key_id=${TGT_ACCESSKEY} >> /tmp/.rclone.conf
    echo secret_access_key=${TGT_SECRETKEY} >> /tmp/.rclone.conf
    echo endpoint=${TGT_ENDPOINT} >> /tmp/.rclone.conf

    echo "S3 config for rclone config parameters"
    cat /tmp/.rclone.conf
    echo ---
}

CONNECT=0

checkS3() {
    echo "2. Checking S3 connection for SOURCE bucket:" $SRC_BUCKET
    SRC_STATUS=$(rclone --config /tmp/.rclone.conf ls COS_SOURCE:${SRC_BUCKET} 2>&1 >/dev/null)
    if [[ "$SRC_STATUS" == *"Failed"* ]]; then 
        echo "ERROR: Check S3 connection details for SOURCE"; 
        CONNECT=1
    else
        echo "SOURCE connection succesful";
    fi

    echo "3. Checking S3 connection for TARGET bucket:" $TGT_BUCKET
    TGT_STATUS=$(rclone --config /tmp/.rclone.conf ls COS_TARGET:${TGT_BUCKET} 2>&1 >/dev/null)
    if [[ "$TGT_STATUS" == *"Failed"* ]]; then
        echo "ERROR: Check S3 connection details for TARGET"; 
        CONNECT=1
    else
        echo "TARGET connection succesful";
    fi
}

MODE=`echo ${1}|tr a-z A-Z`
if [ "$1" != "sync" ] && [ "$1" != "check" ]; then
    echo "Invalid mode"
    echo "Usage: cosbu.sh <sync|check>"
    echo "  sync - Syncronize target bucket with source bucket (also checks)"
    echo "  check - Only compares target and source files/checksums"
    exit 1
fi

echo "Running in" $MODE "mode"

setupS3
checkS3

if [ "$CONNECT" == 1 ]; then
    echo "ERROR: Problem with connection. Exiting."
    exit 1
fi

if [ "$1" == "sync" ]; then 
    rclone --config /tmp/.rclone.conf sync COS_SOURCE:${SRC_BUCKET} COS_TARGET:${TGT_BUCKET}
fi

rclone --config /tmp/.rclone.conf check COS_SOURCE:${SRC_BUCKET} COS_TARGET:${TGT_BUCKET}