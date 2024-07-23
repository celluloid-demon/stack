FROM alpine:latest

WORKDIR /app

COPY ./download-stream ./
COPY config/cronjobs /etc/crontabs/root

RUN apk update && \
    apk upgrade --force && \
    apk add bash curl && \
    chmod +x ./* && \
    mkdir /output

# Start crond with log level 8 in foreground, output to stderr, with redirection to access cronjob output directly from the docker logs.

# NOTE: For people not using alpine, the crond supporting the '-d 8' parameter is not the standard cron, it is the crond command from busybox (which alpine ships with). For example from ubuntu, you can run this as 'busybox crond -f -d 8'. For older versions you have to use '... -L /dev/stdout/'.

CMD ["crond", "-f", "-d", "8", "> /proc/1/fd/1 2> /proc/1/fd/2"]
