#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  rpm --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public  
  until curl -fsSkL -o /etc/yum.repos.d/draios.repo http://download.draios.com/stable/rpm/draios.repo; do
    sleep 1
  done

  yum install --disablerepo=updates -y kernel-devel
  yum install --disablerepo=updates -y sysdig
EOS
