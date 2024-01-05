FROM alpine

RUN apk --update-cache --no-cache add \
    bash \
    shadow \
    uuidgen \
    knock \
    openssh-server \
    && rm -rf /var/cache/apk/*

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.6.2
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN apk --update-cache --no-cache add --virtual .build-deps curl \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})" \
    && apk del .build-deps && rm -rf /var/cache/apk/*
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]

ADD rootfs /
EXPOSE 22
STOPSIGNAL SIGTERM
