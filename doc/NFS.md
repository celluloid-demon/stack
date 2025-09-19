NFS
===

__General notes:__

- Don't forget to add whitelist entry for each new node's ip! (Hint: You may have to restart nfs for changes to take effect and shares to be mounted correctly.)
- It is not uncommon for sqlite and other databases to be corrupted over NFSv3. Reports of that happening over v4 are much less common.

__v3/v4:__

```md
NFSv4 operates over a single tcp port (2049) so it handles firewalls much better. NFSv4 uses larger wsize and rsize so it has better performance in most cases.

I recommend using NFSv4 (4.1 really) but there is a caveat that you need to disable some of the features for it to work seamlessly when you do not have a unified authentication namespace. So save yourself a headache and set NFSv3 ownership model for NFSv4 unless you know what you are doing.
```

Source: https://www.reddit.com/r/freenas/comments/ks2tpk/should_i_be_using_nfs4_instead_of_3/

__sync/async:__

```md
async is the opposite of sync, which is rarely used. async is the default, you don't need to specify that explicitly in releases of nfs-utils up to and including 1.0.0. In all releases after 1.0.0, sync is the default, and async must be explicitly requested if needed.

The option sync means that all changes to the according filesystem are immediately flushed to disk; the respective write operations are being waited for. For mechanical drives that means a huge slow down since the system has to move the disk heads to the right position; with sync the userland process has to wait for the operation to complete. In contrast, with async the system buffers the write operation and optimizes the actual writes; meanwhile, instead of being blocked the process in userland continues to run. (If something goes wrong, then close() returns -1 with errno = EIO.)

SSD: I don't know how fast the SSD memory is compared to RAM memory, but certainly it is not faster, so sync is likely to give a performance penalty, although not as bad as with mechanical disk drives. As of the lifetime, the wisdom is still valid, since writing to a SSD a lot "wears" it off. The worst scenario would be a process that makes a lot of changes to the same place; with sync each of them hits the SSD, while with async (the default) the SSD won't see most of them due to the kernel buffering.

In the end of the day, don't bother with sync, it's most likely that you're fine with async.
```

Source: https://unix.stackexchange.com/questions/146620/difference-between-sync-and-async-mount-options

__Inspiration:__

- `options vers=4.1,nconnect=16,async,rsize=131072,wsize=131072`
- `options vers=4.2,nconnect=16,async,rsize=131072,wsize=131072`
