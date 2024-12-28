Nextcloud
=========

To move a file to the nextcloud data dir and (manually) refresh nextcloud's file index:

- `docker exec -u 3000 -it nextcloud /bin/bash`
- `php /app/www/public/occ files:scan --all`

If nextcloud client constantly asks for login:

- You change the password to a more complex and longer one and everything starts working, OR you remove the ban on the use of simple passwords in the server settings in the “Security” section.
