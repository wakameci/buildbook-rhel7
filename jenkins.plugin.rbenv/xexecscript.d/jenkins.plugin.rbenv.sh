#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  if [[ -d /var/lib/jenkins/.rbenv ]]; then
    exit 0
  fi

  until curl -fSkL -o /tmp/dot.rbenv.tar.gz http://dlc2.wakame.axsh.jp/wakameci/kemumaki-box-rhel7/current/dot.rbenv.tar.gz; do
    sleep 1
  done
  tar zxf /tmp/dot.rbenv.tar.gz -C /var/lib/jenkins/
  rm /tmp/dot.rbenv.tar.gz
EOS
