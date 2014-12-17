#!/bin/bash
#
# requires:
#  bash
#
set -e

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  # # > $ ping 8.8.8.8
  # > ping: icmp open socket: Operation not permitted
  # http://comments.gmane.org/gmane.linux.redhat.fedora.general/409425
  yum reinstall --disablerepo=updates -y iputils
EOS
