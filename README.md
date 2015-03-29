Buildbook for RHEL7
===================

xexecscript/copy.txt/postcopy.txt set for [kemumaki-box-rhel7](https://github.com/wakameci/kemumaki-box-rhel7) based on [vmbuilder](https://github.com/hansode/vmbuilder)

Requirements
------------

+ RHEL/CentOS/Scientific

Usage
-----

```
$ add-book.sh <book-name>
```

```
$ run-book.sh <book-name> <book-name> <book-name> ...
$ CHROOT_DIR=/               run-book.sh <book-name>
$ CHROOT_DIR=/path/to/chroot run-book.sh <book-name>
```

Getting Started
---------------

### 1: Add a book

```
$ ./add-book.sh untitled
generated => untitled
untitled
untitled/copy.txt
untitled/guestroot
untitled/xexecscript.d
untitled/xexecscript.d/untitled.sh
```

`untitled/xexecscript.d/untitled.sh`:

Script will be called with the guest's chroot as first argument, so you can use `chroot $1 <cmd>` to run code in the virtual machine.

```
#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
 #yum install --disablerepo=updates -y :name
EOS
```

`untitled/copy.txt`:

Reading `source dest` lines from FILE, copying source files from host to dest in the guest's file system before running execscript.

```
guestroot/etc/hostname /etc/hostname
```

### 2: Run the book

Run the book in `CHROOT_DIR`(default is `/`).

```
$ sudo CHROOT_DIR=/path/to/chroot ./run-book.sh untitled
```

If you want to run the book on a host, you can set `/` to `CHROOT_DIR` like this.

```
$ sudo CHROOT_DIR= ./run-book.sh untitled
```

Contributing
------------

1. Fork it ( https://github.com/[my-github-username]/buildbook-rhel7/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Links
-----

+ [vmbuider](https://github.com/hansode/vmbuilder)
+ [kemumaki-box-rhel7](https://github.com/wakameci/kemumaki-box-rhel7)
+ [wakame-ci-cluster](https://github.com/wakameci/wakame-ci-cluster)

License
-------

[Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.
