# NOTE: Write your own aliases in local/aliases.sh to avoid losing them after repo updates!
[ $stack = '_'     ] && stack='main'
[ $stack = 'jfm'   ] && stack='jellyfin-music'
[ $stack = 'net'   ] && stack='network'
[ $stack = 'proxy' ] && stack='reverse-proxy'
[ $stack = 'ts'    ] && stack='tailscale'
