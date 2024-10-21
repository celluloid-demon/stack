Raspberry Pi Notes
==================

__Pimox7 Installation Notes:__

- You want the __BULLSEYE__ legacy release of PiOS before installing pimox! (As of time of writing.)
- "Lvm-thin" will not be available in your cluster on this node, you can remove the node from this storage from the cluster storage options.
- Proxmox VE post-install scripts require version 8 of Proxmox or later (they will not work on Pimox7).

__Running virtual machines on Raspberry Pi 4 with Pimox7:__

- __DO THIS SETUP THROUGH PIMOX'S V7 WEB GUI, NOT ANOTHER NODE'S V8 INTERFACE!__
- When first setting up a new vm on Pimox7, in the OS settings check __"Do not use any physical media"__ (we'll get to that later). For the CPU type make sure __"kvm64"__ is selected ("host" may also work). On the Confirm tab, make sure "Start after created" is __UNCHECKED__ (this should be the default).
- After closing the wizard, you may go to your new vm's hardware settings. Change BIOS to __OVMF__ (you can disregard the EFI disk warning, we'll add that next). Click the add button and add an __EFI disk__. Select the cd rom drive and __remove__ it. __Re-add__ it from the add hardware menu and this time choose __SCSI__ for the bus type (at this point you can also __add the ISO installer__ to the vm). Finally, in the VM's options __put the ISO installer first__ in the boot order.
- Install the os for your guest (you may see "Guest has not initialied the display (yet)" several times, this is normal and may be a result of POST messages not showing and just taking a while).
- As it boots for the first time, __be patient <3__.
- After your os is installed, shut it down to remove the install media from the guest.
