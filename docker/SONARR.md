Sonar
=====

Proxy timeout settings to adjust to prevent interactive search from timing out:

```yml
proxy_read_timeout 300;
proxy_connect_timeout 300;
proxy_send_timeout 300;
```

NOTE: The sonarr interactive search may still give a false-negative like "Unable to load results for this episode search", confirm any in-progress searches by peeking at sonarr's logs (you can use portainer for this).

NOTE: Some shows, like Fullmetal Alchemist: Brotherhood, are a single season with an enormous episode count ~60, which takes so long in interactive search that it frequently times-out reverse proxies and fails. You may need to increase timeout to ~20 minutes in these cases (you'll have to perform an interactive search yourself to guage how long a safe timeout value is). Of course the more painless alternative is to just load sonarr directly by its ip.

```
The drive sonarr is using to maintain it’s database correctly is a fuse mount.

You should put it outside of unionfs, give sqlite clean access to proper filesystem capabilities, it needs those to ensure consistency and performance.

PS: Sonarr is running on a dedicated server with a 1gbps connection, so you could say it’s doing fine regarding speed

That means your fs is quite possibly download the entire file, just to access a tiny part of it, and that would definitely cause slowless of the mediainfo stuff. Even though Sonarr needs to get the mediainfo only once, not being able to only dl tiny parts of the file has a significant impact on performance.
Based on a quick scan of the acd_cli docs it should be able to seek. You should be able to test it easily using the mediainfo cmdline utility. (Yes, I repeated that coz you haven’t mentioned you checked that…)
It could be the configured chunk size, or any other number of things.

Either way, it’s not my/our problem. Sry to be blunt, but they come by the dozen, the people who suddenly use cloud drives and expect all their software to behave the same even though the filesystem most certainly isn’t the same.

PS: It’s also possible that the constant db access hits acd instead of unionfs, and thus affects any other fs operation, so get that db out of the union & cloud fs… give it a true and proper local filesystem. You can always set a cronjob to copy a backup periodically.
```

Running app databases (for your containers) on nfs _seems_ to be ill-advised. __Database locks are generally never bugs and are always due to under powered systems that are unable to keep up with the IOps required.__
