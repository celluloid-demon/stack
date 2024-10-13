FROM fedora:latest

# Grab latest version of ansible.
RUN dnf install -y ansible

# Link root ssh dir to docker container volume
RUN ln -s /ssh /root/.ssh

# NOTE: volume, ansible/config:/etc/ansible

# COPY root/ /

# RUN chmod -R +x /app && \
#     chmod -R +x /usr/local/bin

# WORKDIR /app

# CMD [ "bash", "-c", "./entrypoint.sh" ]

# Include available plugins to create a more complete Ansible configuration as follows:
# ansible-config init --disabled -t all > ansible.cfg
