#!/bin/bash
# vim:sw=4:ts=4:et
set -e
ME=$(basename $0)

entrypoint_log() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo "$ME: $@"
	fi
}

entrypoint_log "INFO: Generate random password for root user..."
echo "root:`uuidgen`" | chpasswd

exit 0
