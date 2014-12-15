#!/bin/bash
#
# requires:
#  bash
#
set -e

chroot $1 $SHELL -ex <<'EOS'
  sed -i 's,^keepcache=.*,keepcache=1,' /etc/yum.conf
EOS
