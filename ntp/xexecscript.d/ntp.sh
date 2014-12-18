#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  yum install --disablerepo=updates -y ntp ntpdate

 #chkconfig ntpd    on
 #chkconfig ntpdate on
EOS
