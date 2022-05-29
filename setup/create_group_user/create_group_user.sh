#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
LOG_DIR=${LOG_DIR:-log}

PG_HOST=${PG_HOST:-redshift-cluster-poc.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

cd $BASE_DIR
psql "host=${PG_HOST} port=${PG_PORT} dbname=${PG_DB} user=${PG_USER}" -a -f create_group.sql \
    > "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1
psql "host=${PG_HOST} port=${PG_PORT} dbname=${PG_DB} user=${PG_USER}" -a -f create_user.sql \
    >> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

# Check error
grep -i error "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}.log" \
    | tee "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_error.log" 2>&1

if [ ! -s "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_error.log" ]; then
    echo "Finished successfully!"
    rm "${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_error.log"
else
    echo "Some errors has occuered. Please check ${LOG_DIR}/${SCRIPT_BASE_NAME}_${CURRENT_DATE}_error.log."
fi

