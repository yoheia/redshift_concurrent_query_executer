#!/usr/bin/env bash

export LANG=C
BASE_NAME=$(basename $0 .sh)
CURRENT_DATE=`date '+%Y-%m-%d-%H%M%S'`
BASE_DIR=$(cd $(dirname $0);pwd)
cd $BASE_DIR

SQL_DIR=sql
SCRIPT_PATH=./exec_concurrent_query_by_pgbench.sh

# ベースワークロードを 45 分間実行
PG_CONCURRENCY=4 PG_DURATION=2700 PG_USER=dwh_batch_user SQL_SCRIPT=${SQL_DIR}/lot1_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=2700 PG_USER=dwh_tool_user SQL_SCRIPT=${SQL_DIR}/lot2_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=2700 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/lot3_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=2700 PG_USER=adhoc_l2_user SQL_SCRIPT=${SQL_DIR}/lot3_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=1 PG_TRAN=1 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/lot4_q000000000000000001.sql ${SCRIPT_PATH} &

# 15分スリープ
sleep 900

# 15分間、追加のワークロードを実行
PG_CONCURRENCY=4 PG_DURATION=900 PG_USER=dwh_batch_user SQL_SCRIPT=${SQL_DIR}/lot1_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=900 PG_USER=dwh_tool_user SQL_SCRIPT=${SQL_DIR}/lot2_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=900 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/lot3_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=4 PG_DURATION=900 PG_USER=adhoc_l2_user SQL_SCRIPT=${SQL_DIR}/lot3_q000000000000000001.sql ${SCRIPT_PATH} &
PG_CONCURRENCY=2 PG_TRAN=1 PG_USER=adhoc_l1_user SQL_SCRIPT=${SQL_DIR}/lot4_q000000000000000001.sql ${SCRIPT_PATH} &

# ログからクエリIDやレイテンシを整形して出力
find ./log -name '*.log'|while read LINE
do
    STEM=$(basename ${LINE} .log)
    QUERY_ID=`echo ${STEM}|perl -F'-' -lane 'print qq/$F[1]:$F[2]:$F[3]/'`
    QUERY_LATENCIES=`perl -nle 'print if /statement latencies in milliseconds:/ .. eof' ${LINE}|perl -F'\t' -lane 'print qq/$F[1]:$F[2]/'`
    echo "${QUERY_ID}:${QUERY_LATENCIES}"
done

exit 0
