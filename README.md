Buildbook for RHEL7
===================

xexecscript/copy.txt/postcopy.txt set for [vmbuilder](https://github.com/hansode/vmbuilder)

Requirements
------------

+ RHEL/CentOS/Scientific

xexecscript(*.sh)
-----------------

Run SCRIPT after distro installation finishes.
Script will be called with the guest's chroot as first argument, so you can use `chroot $1 <cmd>` to run code in the virtual machine.

copy.txt/postcopy.txt
---------------------

Read 'source dest' lines from FILE, copying  source  files  from host to dest in the guest's file system.

Getting Started
---------------

Add a new book.

```
$ ./add-book.sh untitled
generated => untitled
untitled
untitled/xexecscript.d
untitled/xexecscript.d/untitled.sh
untitled/copy.txt
untitled/guestroot
```

untitled/xexecscript.d/untitled.sh is a sample execscript.

```
#!/bin/bash
#
# requires:
#  bash
#
set -e

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
 #yum install --disablerepo=updates -y :name
EOS
```

Links
-----

+ [vmbuider](https://github.com/hansode/vmbuilder)
+ [buildbook-rhel6](https://github.com/hansode/buildbook-rhel6)

License
-------

[Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.
