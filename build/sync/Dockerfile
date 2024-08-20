FROM alpine:latest

RUN apk add bash rsync

COPY root/ /

RUN chmod -R +x /app && \
    chmod -R +x /usr/local/bin

WORKDIR /app

CMD [ "bash", "-c", "./entrypoint.sh" ]
