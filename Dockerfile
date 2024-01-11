FROM alpine

RUN apk --update-cache --no-cache add \
    tini \
    bash \
    curl \
    shadow \
    uuidgen \
    openssh-server \
    && rm -rf /var/cache/apk/*

ADD rootfs /
EXPOSE 22
VOLUME [ "/keys", "/authorized_keys.d" ]
ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh"]
CMD [ "/usr/sbin/sshd", "-e", "-D" ]
