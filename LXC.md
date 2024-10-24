LXC (Linux Container) Notes
===========================

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
