#!/bin/bash
# vim:sw=4:ts=4:et
set -e
ME=$(basename $0)
PROXY_USER="${PROXY_USER:-toor}"
PROXY_USER_SSH_DIR="/${PROXY_USER}/.ssh"
AUTHORIZED_KEYS_FILE="${AUTHORIZED_KEYS_FILE:-/run/secrets/authorized_keys}"

entrypoint_log() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo "$ME: $@"
	fi
}

entrypoint_log "INFO: Creating user ${PROXY_USER}..."
mkdir -p /${PROXY_USER} && {
    addgroup ${PROXY_USER}
    adduser --ingroup ${PROXY_USER} --shell /bin/false --home /${PROXY_USER} --no-create-home --gecos ${PROXY_USER} --disabled-password ${PROXY_USER}
    usermod -p '*' ${PROXY_USER}
    chown -R ${PROXY_USER}:${PROXY_USER} /${PROXY_USER}
    chmod -R 700 /${PROXY_USER}
}

entrypoint_log "INFO: Preparing ssh keys..."
if [ -d "${PROXY_USER_SSH_DIR}" ]; then
    rm -rf "${PROXY_USER_SSH_DIR}"
fi

mkdir -p ${PROXY_USER_SSH_DIR} && {
    chmod -R 700 "${PROXY_USER_SSH_DIR}"
    chown -R ${PROXY_USER}:${PROXY_USER} "${PROXY_USER_SSH_DIR}"
}

if [ -f "${AUTHORIZED_KEYS_FILE}" ]; then
    entrypoint_log "INFO: Linking authorized_keys file..."
    cp "${AUTHORIZED_KEYS_FILE}" "${PROXY_USER_SSH_DIR}/authorized_keys"
    chmod 600 "${PROXY_USER_SSH_DIR}/authorized_keys"
    chown -R ${PROXY_USER}:${PROXY_USER} "${PROXY_USER_SSH_DIR}/authorized_keys"
fi

exit 0
