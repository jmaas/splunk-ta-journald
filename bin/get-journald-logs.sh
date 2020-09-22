#!/bin/bash
#
# Simple script to fetch journald logs while keeping state.
# Requires the 'jq' package to be installed.
#

CUR_DIR=$(dirname $0)
STATE_DIR="${CUR_DIR}/../state"
STATE_FILE="${STATE_DIR}/journald.state"
STATE_LOGFILE="${STATE_DIR}/journald.log"


update_state () {
	if [ -s ${STATE_LOGFILE} ]; then
		# only update state if we have a new one
		STATE=$(tail -n1 ${STATE_LOGFILE} | jq -j '.__CURSOR')
		echo -n ${STATE} > ${STATE_FILE}
	fi
}


if [ -s ${STATE_FILE} ]; then
	# get state and logs
	CURSOR=$(cat ${STATE_FILE})
	/usr/bin/journalctl --after-cursor="${CURSOR}" --no-tail --no-pager -o json | /usr/bin/tee ${STATE_LOGFILE}
	update_state
fi


if ! [ -f ${STATE_FILE} ]; then
	# no state (first run?); get logs of today
	/usr/bin/journalctl --no-tail --since today --no-pager -o json | /usr/bin/tee ${STATE_LOGFILE}
	update_state
fi

# EOF
