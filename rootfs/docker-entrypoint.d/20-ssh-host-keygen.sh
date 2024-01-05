#!/bin/bash
# vim:sw=4:ts=4:et
set -e
ME=$(basename $0)

entrypoint_log() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo "$ME: $@"
	fi
}

# check if host keys exist in /keys directory
if [ -f /keys/ssh_host_rsa_key ]; then
    entrypoint_log "INFO: Copying existing ssh host keys from \"/keys\" directory..."
    cp -f /keys/ssh_host_* /etc/ssh
    chmod 600 /etc/ssh/ssh_host_*
else
    entrypoint_log "INFO: Generate new host keys..."
    ssh-keygen -A | while read -r line; do
        entrypoint_log "INFO: $line"
    done
    cp -f /etc/ssh/ssh_host_* /keys
fi

exit 0
