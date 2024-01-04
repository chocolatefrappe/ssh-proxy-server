FROM alpine

RUN apk update && apk add --no-cache \
    bash \
    curl \
    shadow \
    uuidgen \
    openssh-server \
    && rm -rf /var/cache/apk/*
RUN echo "root:`uuidgen`" | chpasswd

# https://github.com/socheatsok78/s6-overlay-installer
ARG S6_OVERLAY_VERSION=v3.1.6.2
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer-minimal.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ENTRYPOINT [ "/init-shim" ]
CMD [ "sleep", "infinity" ]

ADD rootfs /
EXPOSE 22
STOPSIGNAL SIGTERM
# CMD ["/docker-entrypoint.sh"]

# RUN mkdir -p /docker \
#     && addgroup docker \
#     && adduser --ingroup docker --shell /bin/bash --home /docker --no-create-home --gecos docker --disabled-password docker \
#     && chown -R docker:docker /docker \
#     && chmod -R 700 /docker \
#     && usermod -p '*' docker
