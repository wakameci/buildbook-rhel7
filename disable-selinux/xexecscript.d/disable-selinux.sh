#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  if [[ -f /etc/selinux/config ]]; then
    sed -i "s/^\(SELINUX=\).*/\1disabled/" /etc/selinux/config
    egrep ^SELINUX= /etc/selinux/config
  fi
EOS
