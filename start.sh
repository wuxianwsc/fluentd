#!/bin/bash
# 1) FLUENTD_TAG
# 2) FLUENTD_LOG_PATH
# 3) FLUENTD_MATCH
# 4) FLUENTD_HOST
# 5) FLUENTD_PORT
set -e
set -x
FLUENTD_TAG="${1:-default}"
FLUENTD_LOG_PATH="${2:-/usr/local/tomcat/logs}"
FLUENTD_MATCH="${3:-*.*}"
FLUENTD_HOST="${4:-10.1.1.85}"
FLUENTD_PORT="${5:-24224}"

cat > fluent.conf << eof
<source>
  @type forward
  port ${FLUENTD_PORT}
</source>
<source>
  @type tail
  path ${FLUENTD_LOG_PATH}/*.log
  pos_file ${FLUENTD_LOG_PATH}/${FLUENTD_TAG}.log.pos
  tag ${FLUENTD_TAG}
  format none
</source>
<match ${FLUENTD_MATCH}>
  @type forward
  flush_interval 10s
  <server>
    host ${FLUENTD_HOST}
    port ${FLUENTD_PORT}
  </server>
</match>
eof
td-agent -c fluent.conf
