#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
LOG_DIR=${LOG_DIR:-log}

RS_PG_GROUP_NAME=${RS_PG_GROUP_NAME:-poc-auto-wlm}
RS_PG_GROUP_FAMILY=${RS_PG_GROUP_FAMILY:-redshift-1.0}
RS_PG_GROUP_DESC=${RS_PG_GROUP_DESC:-desc_poc-auto-wlm}
RS_PG_JSON=${RS_PG_JSON:-redshift_parameter-group_config.json}
RS_CLUSTER_ID=${RS_CLUSTER_ID:-redshift-cluster-poc}

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

cd $BASE_DIR

aws redshift create-cluster-parameter-group --parameter-group-name ${RS_PG_GROUP_NAME} --parameter-group-family ${RS_PG_GROUP_FAMILY} --description ${RS_PG_GROUP_DESC} \
    >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1
aws redshift modify-cluster-parameter-group --parameter-group-name ${RS_PG_GROUP_NAME} --parameters file://${RS_PG_JSON} \
    >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1
aws redshift modify-cluster --cluster-identifier ${RS_CLUSTER_ID} --cluster-parameter-group-name ${RS_PG_GROUP_NAME} \
    >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

# Sleep 2 min before reboot because modify-cluster is executed asynchronously
sleep 120

aws redshift reboot-cluster --cluster-identifier ${RS_CLUSTER_ID} \
    >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

# Check error
echo "Please check ${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log."
