LXC (Linux Container) Notes
===========================

__To run ARM-based LXC containers:__

- You can grab ARM-based rootfs tarballs [here](https://jenkins.linuxcontainers.org/view/Images/).
- WARNING: Pimox7 seems to have issues creating new LXC containers with ssh pubkey pre-populated, current workaround is to set up ssh keys AFTER container creation.
- WARNING: Issue with the missing ifupdown package / systemd networking is debian-LXC specific. Proxmox GmbH provides amd64 specific LXC containers for Debian. You can try an Ubuntu-based LXC, or follow these steps to get debian-based LXC containers working on Proxmox:
    1. Start debian lxc
    2. enter 'dhclient' without anything in the LXC shell
    3. do 'apt update' && 'apt upgrade'
    4. do 'apt install ifupdown'
    5. change your LXC to dhcp and slaac.
    6. reboot LXC container
    7. login to LXC container shell
    8. type 'ip a'
    -  More info: https://github.com/pimox/pimox7/issues/160
