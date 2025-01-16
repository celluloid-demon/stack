Nextcloud
=========

To move a file to the nextcloud data dir and (manually) refresh nextcloud's file index:

- `docker exec -u 3000 -it nextcloud /bin/bash`
- `php /app/www/public/occ files:scan --all # WARNING: DEPRECATED`
- `occ files:scan --all`

If you get hit with "The polling URL does not start with https..." then try changing from this:

```php
// (plain http by default)
'overwrite.cli.url' => 'http://localhost',

'trusted_domains' => 
  array (
    0 => '127.0.0.1',
    1 => 'localhost',
    2 => 'nextcloud',
    3 => 'nextcloud.sixducks.org',
  ),
```

...to this:

```php
// (note https for BOTH settings here)
'overwrite.cli.url' => 'https://nextcloud.sixducks.org',
'overwriteprotocol' => 'https',

'trusted_domains' => 
  array (
    0 => '127.0.0.1',
    1 => 'localhost',
    2 => 'nextcloud',
    3 => 'nextcloud.sixducks.org',
  ),
```

If nextcloud client constantly asks for login:

- You change the password to a more complex and longer one and everything starts working, OR you remove the ban on the use of simple passwords in the server settings in the “Security” section.
