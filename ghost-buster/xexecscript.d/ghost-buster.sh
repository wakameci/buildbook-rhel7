#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  releasever=$(< /etc/yum/vars/releasever)

  arch=$(arch)
  case "${arch}" in
    i*86)   basearch=i386 arch=i686 ;;
    x86_64) basearch=${arch} ;;
  esac

  case "${releasever}" in
    7.0.1406)
      yum install -y \
        glibc \
        glibc-common \
        glibc-devel \
        glibc-headers

      yum update  -y \
        glibc \
        glibc-common \
        glibc-devel \
        glibc-headers
      ;;
  esac
EOS
