stack
=====

Most of my homelab services are defined here.

Quickstart:

- Simply run the entrypoint script `up.sh <STACK_NAME>` without configuring anything, and it will report any failed healthchecks and advise how to remedy (more info: `hooks/docker-compose.sh`).
- NOTE: Names in the allow list are docker compose project names, which `up.sh` gets from `docker-compose.<PROJECT_NAME>.yml`.

Requirements:

- A configured `.env` file in project root (this can be a symlink to a file in the env folder to store multiple env files for multiple machines, see examples).
- A configured `.allow` file in project root (this can also be symlinked from the allow folder).
