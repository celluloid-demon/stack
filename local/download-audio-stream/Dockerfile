FROM alpine:latest

RUN apk add bash curl

COPY root/ /

RUN chmod -R +x /usr/local/bin

# NOTE: For people not using alpine, the crond supporting the '-d 8' parameter is not the standard cron, it is the crond command from busybox (which alpine ships with). For example from ubuntu, you can run this as 'busybox crond -f -d 8'. For older versions you have to use '... -L /dev/stdout/'.

# Start crond with log level 8 in foreground, output to stderr, with redirection to access cronjob output directly from the docker logs.
CMD ["crond", "-f", "-d", "8"]
