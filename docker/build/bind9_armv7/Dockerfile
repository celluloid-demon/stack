FROM debian:bookworm

RUN apt update
RUN apt install -y bind9

EXPOSE 53/tcp
EXPOSE 53/udp

# Default: root:root
# USER bind:bind

# -f: run in foreground (to keep container running)
CMD ["/usr/sbin/named", "-f"]
