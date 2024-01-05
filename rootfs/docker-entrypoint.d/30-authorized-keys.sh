#!/bin/bash
# vim:sw=4:ts=4:et
set -e
ME=$(basename $0)
PROXY_USER="${PROXY_USER:-toor}"
PROXY_USER_HOME="/tmp/${PROXY_USER}"
PROXY_USER_SSH_DIR="${PROXY_USER_HOME}/.ssh"
AUTHORIZED_KEYS_FILE="${AUTHORIZED_KEYS_FILE:-/run/secrets/authorized_keys}"

entrypoint_log() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo "$ME: $@"
	fi
}
entrypoint_log_n() {
	if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
		echo -n "$ME: $@"
	fi
}

entrypoint_log "INFO: Creating \"${PROXY_USER}\" user/group..."
mkdir -p ${PROXY_USER_HOME} && {
	addgroup ${PROXY_USER}
	adduser --ingroup ${PROXY_USER} --shell /bin/false --home ${PROXY_USER_HOME} --no-create-home --gecos ${PROXY_USER} --disabled-password ${PROXY_USER}
	usermod -p '*' ${PROXY_USER}
	chown -R ${PROXY_USER}:${PROXY_USER} ${PROXY_USER_HOME}
	chmod -R 700 ${PROXY_USER_HOME}
}

if [ -d "${PROXY_USER_SSH_DIR}" ]; then
	entrypoint_log "INFO: Remove existing \"authorized_keys\"..."
	rm -rf "${PROXY_USER_SSH_DIR}"
fi
mkdir -p ${PROXY_USER_SSH_DIR} && {
	touch "${PROXY_USER_SSH_DIR}/authorized_keys"
	chmod -R 700 "${PROXY_USER_SSH_DIR}"
	chown -R ${PROXY_USER}:${PROXY_USER} "${PROXY_USER_SSH_DIR}"
}

entrypoint_log_n "INFO: Import authorized keys from \"/authorized_keys.d\" directory..."
if [ -d "/authorized_keys.d" ]; then
	for f in /authorized_keys.d/*; do
		if [ -f "${f}" ]; then
			echo -n " ["
			cat "${f}" | while read line; do
				echo -n "#"
				echo "${line}" >> "${PROXY_USER_SSH_DIR}/authorized_keys"
			done
			echo -n "]" && echo
		fi
	done
fi && echo

entrypoint_log_n "INFO: Import authorized keys form \"${AUTHORIZED_KEYS_FILE}\" secret..."
if [ -f "${AUTHORIZED_KEYS_FILE}" ]; then
	echo -n " ["
	cat "${AUTHORIZED_KEYS_FILE}" | while read line; do
		echo -n "#"
		echo "${line}" >> "${PROXY_USER_SSH_DIR}/authorized_keys"
	done
	echo -n "]"
fi && echo

exit 0
