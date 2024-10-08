stack
=====

Most of my homelab services are defined here.

Requirements:

1. A configured `.env` file in project root (this can be a symlink to a file in the env folder to store multiple env files for multiple machines, see examples).
2. A configured `.allow` file in project root (this can also be symlinked from the allow folder).
3. Run `up.sh <PROJECT_NAME>`.

Notes:

- Names in the allow list are docker compose project names, which `up.sh` gets from `docker-compose.<PROJECT_NAME>.yml`.
