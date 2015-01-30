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

# "gcc"/"gcc-c++" depends on glibc* which is pached in "ghost-buster".
#
# 7.0.1406)
#   "ghost-buster" updates glibc-* using updates yum repository.
#   because gcc must not disable updates yum repository.
#
# Error: Package: gcc-c++-4.8.2-16.el7.x86_64 (base)
#            Requires: gcc = 4.8.2-16.el7
#            Installed: gcc-4.8.2-16.2.el7_0.x86_64 (@updates)
#                gcc = 4.8.2-16.2.el7_0
#            Available: gcc-4.8.2-16.el7.x86_64 (base)
#                gcc = 4.8.2-16.el7
#

chroot $1 $SHELL -ex <<'EOS'
  releasever=$(< /etc/yum/vars/releasever)

  case "${releasever}" in
    7.0.1406)
      yum install -y \
        gcc \
        gcc-c++
      ;;
    *)
      yum install --disablerepo=updates -y \
        gcc \
        gcc-c++
      ;;
  esac
EOS
