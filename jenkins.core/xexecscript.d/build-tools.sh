#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  yum install --disablerepo=updates -y \
    qemu-kvm qemu-img \
  yum install --disablerepo=updates -y \
    parted kpartx \
  yum install --disablerepo=updates -y \
    rpm-build automake createrepo \
  yum install --disablerepo=updates -y \
    openssl-devel zlib-devel readline-devel
EOS

# "gcc" depends on glibc* which is pached in "ghost-buster".
#
# 7.0.1406)
#   "ghost-buster" updates glibc-* using updates yum repository.
#   because gcc must not disable updates yum repository.

chroot $1 $SHELL -ex <<'EOS'
  releasever=$(< /etc/yum/vars/releasever)

  case "${releasever}" in
    7.0.1406)
      yum install -y \
        gcc
      ;;
    *)
      yum install --disablerepo=updates -y \
        gcc
      ;;
  esac
EOS

chroot $1 $SHELL -ex <<'EOS'
  yum install --disablerepo=updates -y \
    gcc-c++
EOS
