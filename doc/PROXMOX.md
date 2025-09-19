Proxmox Cheat Sheet
===================

__[Proxmox VE Raspberry Pi Port](https://github.com/jiangcuo/Proxmox-Port/wiki)__

Wiki for installing Proxmox v8 on Pi (don't forget to set root password for gui login with `passwd`).

__[Proxmox VE Post Install](https://tteck.github.io/Proxmox/#proxmox-ve-post-install)__

This script provides options for managing Proxmox VE repositories, including disabling the Enterprise Repo, adding or correcting PVE sources, enabling the No-Subscription Repo, adding the test Repo, disabling the subscription nag, updating Proxmox VE, and rebooting the system.

__Setting up NFS storage:__

- If exporting your NFS share from TrueNAS (which uses v3 by default - at time of writing), remember to __set v3 when adding the share__ to proxmox!
- NOTE: Proxmox 8 (at time of writing) has issues correctly unmounting/removing NFS shares (confirm with `df -h`). To completely remote/unmount an NFS share from proxmox, try: `umount -f -l /mnt/pve/<share>`.
- __WARNING: YOU MAY HAVE TO DO THE ABOVE FOR *EVERY* PROXMOX NODE IN YOUR CLUSTER TO COMPLETELY AND CORRECTLY REMOVE THE NFS SHARE FROM IT.__

__Removing nodes on a two-node cluster:__

```

Just to expand on this more: the expected command tells the pve cluster how many votes (active nodes that can communicate with each other) are required for a quorum.

Normally you want this to be (at least) 51% of nodes, which is why 3 is the recommended minimum cluster nodes for a production environment. If you have two nodes and, say, your switch goes down and they lose communication, both nodes will see 1 vote and be below quorum, so they will freeze and eventually reboot as the watchdog tries an”have you tried turning it off and turning it on again” approach to re-establishing a connection to the other cluster member.

This is also why it is wise to have a second physical network for a backup corosync ring, so if you DO lose a network, the other one prevents nodes from freaking out over nothing.

pvecm here appears to not let you break quorum by removing an active node. If you set the expected votes to 1, removing a node will not break quorum (the remaining node’s vote will be enough).

Obviously before you do this, make sure your VMs and Containers are migrated to the node you are keeping, or shut down if you no longer want them.

```

Source: https://www.reddit.com/r/Proxmox/comments/s3z0gw/removing_node_from_2_node_cluster/

__Removing orphaned containers on a deleted node:__

- You can usually find orphaned node data hiding in: `/etc/pve/nodes/`.
