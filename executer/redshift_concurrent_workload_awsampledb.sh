#!/usr/bin/env bash

export LANG=C
BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

SQL_DIR=sql
SCRIPT_PATH=./exec_concurrent_query_by_pgbench.sh

# Execute redshift_perf.sh
# Pass arguments by shell variables
PG_CONCURRENCY=8 PG_DURATION=900 PG_USER=dwh_batch_user SQL_SCRIPT=${SQL_DIR}/sample_query1.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=8 PG_DURATION=900 PG_USER=dwh_tool_user SQL_SCRIPT=${SQL_DIR}/sample_query2.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=8 PG_DURATION=900 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/sample_query3.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=8 PG_DURATION=900 PG_USER=adhoc_l2_user SQL_SCRIPT=${SQL_DIR}/sample_query3.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=8 PG_DURATION=900 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/sample_query4.sql ${SCRIPT_PATH} &

exit 0
