stack
=====

Most of my homelab services are defined here.

Requirements:

- Docker.
- A configured `.env` file in project root (this can be a symlink to a file in the env folder to store multiple env files for multiple machines, see examples).
- A configured `.allow` file in project root (this can also be symlinked from the allow folder).

Quickstart:

- Create an env file for your local machine in the env folder, and symlink it as `.env` in project root (to get started you may copy one of the example env files and customize it for your setup). This allows the git repo to keep multiple env files.
- Simply run the entrypoint script `up.sh <STACK_NAME>`__(*)__ without configuring anything, and it will report any failed healthchecks and advise how to remedy (more info: `hooks/docker-compose.sh`).
  - __(*)__ Names in the allow list are docker compose project names, which `up.sh` gets from `docker-compose.<PROJECT_NAME>.yml`.
