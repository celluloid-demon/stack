FROM alpine:3.20.2

RUN apk add bash rsync

COPY root/ /

RUN chmod -R +x /app && \
    chmod -R +x /usr/local/bin

WORKDIR /app

# todo add logic to copy ssh private key(s) to /root/.ssh/...

CMD [ "bash", "-c", "./entrypoint.sh" ]
