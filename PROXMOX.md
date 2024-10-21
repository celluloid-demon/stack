Proxmox Cheat Sheet
===================

__[Proxmox VE Post Install](https://tteck.github.io/Proxmox/#proxmox-ve-post-install)__

This script provides options for managing Proxmox VE repositories, including disabling the Enterprise Repo, adding or correcting PVE sources, enabling the No-Subscription Repo, adding the test Repo, disabling the subscription nag, updating Proxmox VE, and rebooting the system.

__Setting up NFS storage:__

- If exporting your NFS share from TrueNAS (which uses v3 by default - at time of writing), remember to __set v3 when adding the share__ to proxmox!
