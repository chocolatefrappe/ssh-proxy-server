FROM alpine

RUN apk --update-cache --no-cache add \
    tini \
    bash \
    shadow \
    uuidgen \
    openssh-server \
    envsubst \
    && rm -rf /var/cache/apk/*

ADD rootfs /
EXPOSE 22
VOLUME [ "/keys" ]
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD [ "/usr/sbin/sshd", "-e", "-D" ]
# STOPSIGNAL SIGTERM
