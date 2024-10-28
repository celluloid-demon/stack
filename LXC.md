LXC (Linux Container) Notes
===========================

__Bindmounts for granting unprivileged containers access to host-mounted NFS shares:__

- https://pve.proxmox.com/wiki/Unprivileged_LXC_containers#Using_local_directory_bind_mount_points
- Hint: You can group your nfs mounts intended for your docker lxc runtimes (eg under '/mnt/docker/') by editing their mount points directly in: `/etc/pve/storage.cfg`.

__To run ARM-based LXC containers:__

- You can grab ARM-based rootfs tarballs [here](https://jenkins.linuxcontainers.org/view/Images/).
- WARNING: Pimox7 seems to have issues creating new LXC containers with ssh pubkey pre-populated, current workaround is to set up ssh keys AFTER container creation.
- WARNING: As a general rule, use PVE8 interface/node to create LXC containers for v8 nodes, and use PVE7 interface/node (read: PiMox7) to create LXC containers for v7 nodes (after which you can start v7 AND v8 nodes from a v8 interface).
- WARNING: Issue with the missing ifupdown package / systemd networking is debian-LXC specific (debian 11 and later). Proxmox GmbH provides amd64 specific LXC containers for Debian. You can try an Ubuntu-based LXC, or follow these steps to get debian-based LXC containers working on Proxmox:
    1. Start debian lxc
    2. enter 'dhclient' without anything in the LXC shell (it may report an ip address is already assigned)
    3. do 'apt update' && 'apt upgrade'
    4. do 'apt install ifupdown'
    5. change your LXC to dhcp and slaac.
    6. reboot LXC container
    7. login to LXC container shell
    8. type 'ip a'
    -  More info: https://github.com/pimox/pimox7/issues/160

__Exposing /dev/net/tun to Proxmox LXC:__

1. Stop the container
2. Edit the container's config file: `nano /etc/pve/lxc/<container_id>.conf`
3. Add the following lines:
```yml
lxc.cgroup.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
```
```md
The first line allows the container to create character devices with major number 10 and minor number 200, which corresponds to /dev/net/tun. The second line mounts /dev/net/tun from the host to the container.Alternatively, if you prefer using the web interface, you can add these settings via the Resources > Configuration > Options in the container settings.
```
Source: https://community.bigbeartechworld.com/t/exposing-dev-net-tun-to-proxmox-lxc/198
4. Load the TUN module in the host kernel: `modprobe tun`
5. Add `tun` to `/etc/modules-load.d/modules.conf` (makes persistent across reboots)
6. Test inside running container: `ls -al /dev/net/tun`
