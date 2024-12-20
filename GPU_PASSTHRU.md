GPU Passthrough
===============

__TLDR__

- Just grab a proxmox helper script for installing a jellyfin lxc runtime w/ hardware acceleration.
- Bonus points if you swap the internal jellyfin install for docker!

__Longer explanation__

Source: https://bookstack.swigg.net/books/linux/page/lxc-gpu-access

```
Giving a LXC guest GPU access allows you to use a GPU in a guest while it is still available for use in the host machine. This is a big advantage over virtual machines where only a single host or guest can have access to a GPU at one time. Even better, multiple LXC guests can share a GPU with the host at the same time.

- The information on this page is written for a host running Proxmox but should be easy to adapt to any machine running LXC/LXD.
- Since a device is being shared between two systems there are almost certainly some security implications and I haven't been able to determine what degree of security you're giving up to share a GPU.

Determine Device Major/Minor Numbers

To allow a container access to the device you'll have to know the devices major/minor numbers. This can be found easily enough by running ls -l in /dev/. As an example to pass through the integated UHD 630 GPU from an Core i7 8700k you would first list the devices where are created under /dev/dri.
```

```sh
root@blackbox:~# ls -l /dev/dri
total 0
drwxr-xr-x 2 root root         80 May 12 21:54 by-path
crw-rw---- 1 root video  226,   0 May 12 21:54 card0
crw-rw---- 1 root render 226, 128 May 12 21:54 renderD128
```

```
From that you can see the major device number is 226 and the minors are 0 and 128.

Provide LXC Access

In the configuration file you'd then add lines to allow the LXC guest access to that device and then also bind mount the devices from the host into the guest. In the example above since both devices share the same major number it is possible to use a shorthand notation of 226:* to represent all minor numbers with major number 226.
```

```sh
# /etc/pve/lxc/*.conf
+ lxc.cgroup.devices.allow: c 226:* rwm
+ lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file,mode=0666
+ lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
```

```
Allow unprivileged Containers Access

In the example above we saw that card0 and renderD128 are both owned by root and have their groups set to video and render. Because the "unprivilged" part of LXC unprivileged container works by mapping the UIDs (user IDs) and GIDs (group IDs) in the LXC guest namespace to an unused range of IDs on host, it is necessary to create a custom mapping for that namespace that maps those groups in the LXC guest namespace to the host groups while leaving the rest unchanged so you don't lose the added security of running an unprivilged container.

First you need to give root permission to map the group IDs. You can look in /etc/group to find the GIDs of those groups, but in this example video = 44 and render = 108 on our host system. You should add the following lines that allow root to map those groups to a new GID.
```

```sh
# /etc/subgid
+ root:44:1
+ root:108:1
```

```
Then you'll need to create the ID mappings. Since you're just dealing with group mappings the UID mapping can be performed in a single line as shown on the first line addition below. It can be read as "remap 65,536 of the LXC guest namespace UIDs from 0 through 65,536 to a range in the host starting at 100,000." You can tell this relates to UIDs because of the u denoting users. It wasn't necessary to edit /etc/subuid because that file already gives root permission to perform this mapping.

You have to do the same thing for groups which is the same concept but slightly more verbose. In this example when looking at /etc/group in the LXC guest it shows that video and render have GIDs of 44 and 106. Although you'll use g to denote GIDs everything else is the same except it is necessary to ensure the custom mappings cover the whole range of GIDs so it requires more lines. The only tricky part is the second to last line that shows mapping the LXC guest namespace GID for render (106) to the host GID for render (108) because the groups have different GIDs.
```

```sh
# /etc/pve/lxc/*.conf
  lxc.cgroup.devices.allow: c 226:* rwm
  lxc.mount.entry: /dev/dri/card0 dev/dri/card0 none bind,optional,create=file,mode=0666
  lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file
+ lxc.idmap: u 0 100000 65536
+ lxc.idmap: g 0 100000 44
+ lxc.idmap: g 44 44 1
+ lxc.idmap: g 45 100045 61
+ lxc.idmap: g 106 108 1
+ lxc.idmap: g 107 100107 65429
```

```
Beaues it can get confusing to read I just wanted show each line with some comments...
```

```sh
+ lxc.idmap: u 0 100000 65536    // map UIDs 0-65536 (LXC namespace) to 100000-165535 (host namespace)
+ lxc.idmap: g 0 100000 44       // map GIDs 0-43 (LXC namspace) to 100000-100043 (host namespace)
+ lxc.idmap: g 44 44 1           // map GID  44 to be the same in both namespaces
+ lxc.idmap: g 45 100045 61      // map GIDs 45-105 (LXC namspace) to 100045-100105 (host namespace)
+ lxc.idmap: g 106 108 1         // map GID  106 (LXC namspace) to 108 (host namespace)
+ lxc.idmap: g 107 100107 65429  // map GIDs 107-65536 (LXC namspace) to 100107-165536 (host namespace)
```

```
Add root to Groups

Because root's UID and GID in the LXC guest's namespace isn't mapped to root on the host you'll have to add any users in the LXC guest to the groups video and render to have access the devices. As an example to give root in our LXC guest's namespace access to the devices you would simply add root to the video and render group.
```

```sh
usermod --append --groups video,render root
```

__lxc.mount.entry - static uid/gid in LXC guest__

Source: https://www.reddit.com/r/Proxmox/comments/q5wbl0/lxcmountentry_static_uidgid_in_lxc_guest/

```
I am passing through the render device of my Ryzen APU to my Arch Linux LXC which is working pretty well.

However I noticed something strange. Sometimes after rebooting my PVE host the GID of group render changes from 108 to a random GID of a non-existent group (on the host). Thus the device also has a different GID inside the LXC making it inaccessible for Jellyfin.

Is it somehow possible to specify the target UID/GID to which the device will belong to inside the LXC? Something like this is not working.
```

```sh
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file,uid=0,gid=989

989=render (inside the LXC)
```

```
What is the best way of solving this? Should I simply create a script chown -R root:render /dev/dri/renderD128 inside the LXC that runs each time the Jellyfin service starts? Or is there a better solution to this?

EDIT (SOLVED):
```

```sh
# the two lines below are necessary for both unprivileged and privileged LXCs
lxc.cgroup2.devices.allow: c 226:128 rwm
lxc.mount.entry: /dev/dri/renderD128 dev/dri/renderD128 none bind,optional,create=file

# also add line below, if you use an unprivileged LXC
lxc.hook.pre-start: sh -c "chown 0:100989 /dev/dri/renderD128"

# also add line below, if you use a privileged LXC
lxc.hook.pre-start: sh -c "chown 0:989 /dev/dri/renderD128"
```

```
This will run chown 0:989 /dev/dri/renderD128 (privileged LXC) or chown 0:100989 /dev/dri/renderD128 (unprivileged LXC) on the PVE host before starting the LXC, giving group render access to the render device.

https://linuxcontainers.org/lxc/manpages/man5/lxc.container.conf.5.html#lbBH

EDIT 2 (2021/12):

My solution should now work for both unprivileged and privileged LXCs.
```
