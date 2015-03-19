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
  majorver=${releasever%%.*}

  case "${releasever}" in
    *)
      ;;
  esac

  openvswitch_version=2.3.1

  yum install --disablerepo=updates -y http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/${releasever}/kmod-openvswitch-${openvswitch_version}-1.el${majorver}.centos.x86_64.rpm
  yum install --disablerepo=updates -y http://dlc.openvnet.axsh.jp/packages/rhel/openvswitch/${releasever}/openvswitch-${openvswitch_version}-1.x86_64.rpm
EOS
