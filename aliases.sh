
# NOTE: Write your own aliases in local/aliases.sh to avoid losing them after
# repo updates!

[ $stack = '_'         ] && stack='main'
[ $stack = 'jf'        ] && stack='jellyfin'
[ $stack = 'jfm'       ] && stack='jellyfin-music'
[ $stack = 'proxy'     ] && stack='nginx-proxy-manager'
[ $stack = 'proxy-alt' ] && stack='nginx-proxy-manager-alt'
[ $stack = 'ts'        ] && stack='tailscale'

true
