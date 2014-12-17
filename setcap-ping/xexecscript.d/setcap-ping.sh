#!/bin/bash
#
# requires:
#  bash
#
set -e

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  getcap /bin/ping
  getcap /bin/ping6

  setcap cap_net_raw+ep /bin/ping
  setcap cap_net_raw+ep /bin/ping6

  getcap /bin/ping
  getcap /bin/ping6
EOS
