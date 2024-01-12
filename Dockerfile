FROM alpine

RUN apk --update-cache --no-cache add \
    bash \
    curl \
    shadow \
    uuidgen \
    openssh-server \
    ssh-import-id \
    inotify-tools \
    && rm -rf /var/cache/apk/*

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.6.2
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"

ADD rootfs /
EXPOSE 22
ENV DATA_DIR=/data
VOLUME [ "${DATA_DIR}", "/authorized_keys.d" ]
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]
