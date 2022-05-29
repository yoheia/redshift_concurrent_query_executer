#!/usr/bin/env bash

export LANG=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

# Default value set, if shell variables are not pased
PG_HOST=${PG_HOST:-redshift-cluster-poc.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
SQL_SCRIPT=${SQL_SCRIPT:-exec_all_ddl_copy.sql}

LOG_DIR=${LOG_DIR:-log}
SQL_BASE_NAME=$(basename ${SQL_SCRIPT} .sql)

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

# Execute custom query by pgbench
psql "host=${PG_HOST} user=${PG_USER} dbname=${PG_DB} port=${PG_PORT}" -a -f ${SQL_SCRIPT} \
	> "${LOG_DIR}/${SCRIPT_BASE_NAME}_${SQL_BASE_NAME}_${CURRENT_DATE}.log" 2>&1

grep -i error "${LOG_DIR}/${SCRIPT_BASE_NAME}_${SQL_BASE_NAME}_${CURRENT_DATE}.log" \
    | tee "${LOG_DIR}/${SCRIPT_BASE_NAME}_${SQL_BASE_NAME}_${CURRENT_DATE}_summary.log" 2>&1

exit 0
