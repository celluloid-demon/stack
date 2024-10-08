stack
=====

Most of my homelab services are defined here.

__Requirements:__

- Docker.
- A configured `.env` file in project root.
- A configured `.allow` file in project root.
  - NOTE: I run this same repo on multiple devices - the allow list is mostly to prevent me from accidentally pulling unwanted images on the wrong machine.
  - NOTE: Names in the allow list are docker compose project names, which `up.sh` gets from STACK_NAME in `docker-compose.<STACK_NAME>.yml`.

__Quickstart:__

- Create symlinks for your `.env` and `.allow` files in project root and configure them (you may copy the example files in the env/allow folders respectively and customize them for your specific machine). This allows the git repo to keep multiple env/allow files for multiple machines.
- Simply run the entrypoint script `up.sh <STACK_NAME>` without configuring anything, and it will report any failed healthchecks and usually advise how to remedy (more info: `hooks/docker-compose.sh`).
