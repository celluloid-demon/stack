Nextcloud
=========

To move a file to the nextcloud data dir and (manually) refresh nextcloud's file index:

- `docker exec -u 3000 -it nextcloud /bin/bash`
- `php /app/www/public/occ files:scan --all`
