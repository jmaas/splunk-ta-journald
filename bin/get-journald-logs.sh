#!/bin/bash
#
# Simple script to fetch journald logs while keeping state.
# Requires the 'jq' package to be installed.
#

#LOG_DATE=$(date +"%Y-%m-%d")
#LOG_NAME="journald-${LOG_DATE}.log"
#LOG_DIR="/var/log/splunk-journald"
#LOG_FILE="${LOG_DIR}/${LOG_NAME}"

STATE_NAME="journald.state"
STATE_DIR="state"
STATE_FILE="${STATE_DIR}/${STATE_NAME}"

#if ! [ -d ${LOG_DIR} ]; then
#	mkdir -p ${LOG_DIR}
#fi

#if ! [ -d ${STATE_DIR} ]; then
#	mkdir -p ${STATE_DIR}
#fi

if [ -f ${STATE_FILE} ]; then
	# get state and logs
	CURSOR=$(cat ${STATE_FILE})
     	/usr/bin/journalctl --after-cursor="${CURSOR}" --no-tail --no-pager -o json # >> ${LOG_FILE}
else
	# no state; get all logs as of today
	/usr/bin/journalctl --no-tail --since today --no-pager -o json # >> ${LOG_FILE}
fi

# update state
STATE=$(tail -n1 ${LOG_FILE} | jq -r '.__CURSOR')
echo ${STATE} > ${STATE_FILE}

# EOF

