SmartCTL
========

Troubleshooting bad sectors
---------------------------

**Recommended reading:**

```

On btrfs and ZFS, the designers have decided that a floppy-era bad block list is not needed any more. They are usually right as long as you write over the defects (see above). Reading will still hang from retrying.

...On modern spinning drives, smartctl -t long /dev/device (see S.M.A.R.T.) performs a full read-only test. It will halt as soon as a failure is found and record it as a "LBA_of_first_error" data entry, which you can then overwrite with hdparm.

...It is possible to force a write using the badblocks list from non-destructive testing. One would need to calculate the LBA ranges, use hdparm --read-sector to narrow it down to single sectors, and finally use hdparm --write-sector [1] to trigger the write. You would be giving up on any possible future retries at this sector, but at least no more read hangs would occur.

```

Source: https://wiki.archlinux.org/title/Badblocks

A few bad sectors are normal in a hard disk's life, but sometimes - _sometimes_ - data is lost to these sectors, and can't be recovered. The only way I know to successfully restore a disk from this state is the following, using smartctl and hdparm:

```zsh

# First, find the first bad sector (it is a "LBA_of_first_error" data entry).
smartctl --xall /dev/sdX

# Note: `--all` is a bit misleading, it only shows legacy smart info, use `--xall` for e[x]tended info to review LBA_of_first_error's value.

# Confirm first bad sector.
hdparm --read-sector /dev/sdX <BAD SECTOR>

# Attempt to read following sectors until the bad sector range is mapped-out (save time with a binary search, of course).
hdparm --read-sector /dev/sdX <TEST SECTOR>
hdparm --read-sector /dev/sdX <TEST SECTOR>
hdparm --read-sector /dev/sdX <TEST SECTOR>
# etc...

# "Repair" each bad sector.
hdparm --write-sector /dev/sdX <BAD SECTOR>
hdparm --write-sector /dev/sdX <BAD SECTOR>
hdparm --write-sector /dev/sdX <BAD SECTOR>
# etc...

# Now we can safely re-initialize the disk, and the vdev should re-silver it using only working sectors. EXPORT the disk to make the vdev "forget" it (don't just "offline" it), then "extend" the vdev with the same disk.

```

Future mitigation: Zero-out entire disk when you first get it BEFORE adding it to production raid array, should help avoid most surprises when buying new disks.

```zsh

dd if=/dev/zero of=/dev/sdX bs=4M

```
