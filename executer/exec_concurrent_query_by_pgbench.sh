#!/usr/bin/env bash

export LC_ALL=C
SCRIPT_BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y%m%d_%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

# Default value set, if shell variables are not pased
PGBENCH_PATH=${PGBENCH_PATH:-/usr/pgsql-13/bin/pgbench}
#PGBENCH_PATH=${PGBENCH_PATH:-pgbench}
PG_HOST=${PG_HOST:-redshift-cluster-poc.ceyg6jv96hfq.ap-northeast-1.redshift.amazonaws.com}
PG_USER=${PG_USER:-awsuser}
PG_DB=${PG_DB:-dev}
PG_PORT=${PG_PORT:-5439}
SQL_SCRIPT=${SQL_SCRIPT:-sql/pg_tables.sql}
PG_CONCURRENCY=${PG_CONCURRENCY:-1}
PG_DURATION=${PG_DURATION:-10}
LOG_DIR=${LOG_DIR:-log}
SQL_BASE_NAME=$(basename ${SQL_SCRIPT} .sql)

# create log directory, if not exist.
if [ ! -d "${LOG_DIR}" ]
then
    mkdir ${LOG_DIR}
fi

# Execute custom query by pgbench
${PGBENCH_PATH} -r -c ${PG_CONCURRENCY} -j ${PG_CONCURRENCY} -n -T ${PG_DURATION} -f ${SQL_SCRIPT} -U ${PG_USER} -h ${PG_HOST} -d ${PG_DB} -p ${PG_PORT} \
	> "${LOG_DIR}/${SCRIPT_BASE_NAME}-${PG_USER}-${SQL_BASE_NAME}-${CURRENT_DATE}.log" 2>&1

exit 0
