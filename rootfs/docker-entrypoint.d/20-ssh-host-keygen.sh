#!/bin/bash
# vim:sw=4:ts=4:et
set -e
ME=$(basename $0)
DATA_DIR="${DATA_DIR:-/data}"

entrypoint_log() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo "$ME: $@"
	fi
}

# check if host keys exist in DATA_DIR directory
if [ -f "${DATA_DIR}/ssh_host_rsa_key" ]; then
{
	entrypoint_log "INFO: Copying existing ssh host keys from \"${DATA_DIR}\" directory..."
	cp -f ${DATA_DIR}/ssh_host_* /etc/ssh
	chmod 600 /etc/ssh/ssh_host_*
}
else
{
	entrypoint_log "INFO: Generate new host keys..."
	ssh-keygen -A | while read -r line; do
		entrypoint_log "INFO: $line"
	done
	entrypoint_log "INFO: Copying generated host keys to \"${DATA_DIR}\" directory..."
	cp -f /etc/ssh/ssh_host_* ${DATA_DIR}
}
fi

# Checking host keys
{
	ls /etc/ssh/ssh_host_*.pub | while read -r line; do
		entrypoint_log "INFO: Showing host keys fingerprint: $line"
		ssh-keygen -lvf "$line"
	done
}

exit 0
