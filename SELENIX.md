SELinux
=======

```plaintext
Hello,

I would like my container to access (r/w) a host directory, but all I can get is “permision denied”.

Here is a basic example:
```

```plaintext
$ podman run -ti --rm  -v /tmp:/aaa -v ~/:/bbb fedora:31
[root@fe13abffe7f1 /]# ls -ld aaa bbb
drwxrwxrwt. 17 nobody nobody  360 Jan  4 11:47 aaa
drwx--x--x. 55 root   root   4096 Jan  4 11:38 bbb
[root@fe13abffe7f1 /]# ls -l aaa bbb
ls: cannot open directory 'aaa': Permission denied
ls: cannot open directory 'bbb': Permission denied
[root@fe13abffe7f1 /]#
```

```plaintext
Am I doing something wrong according to Silverblue security rules ?I am running Silverblue 31, and trying to migrate my usual containers on it…
```

```plaintext
This is most likely due to SELinux labeling/protection. You can add :z to the end of the --volume option specification to relabel files in the shared directories so that they can be accessed from a container. man podman-run for more information. I would consider the implications of this, though. You most likely only want to relabel files that you explicitly want to share in the container. Putting those files into a separate directory will help. For your home directory sharing, maybe you would prefer to use a tool like [toolbox](https://github.com/containers/toolbox) to set up these containers for you.
```

Source: https://discussion.fedoraproject.org/t/cannot-access-host-filesystem-from-podman-containers/14290
