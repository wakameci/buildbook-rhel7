#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  yum install --disablerepo=updates -y curl unzip
EOS

chroot $1 $SHELL -ex <<'EOS'
  # Download and install Serf
  cd /tmp
  case "$(arch)" in
  x86_64) arch=amd64 ;;
    i*86) arch=386   ;;
  esac

  until curl -fsSkL -o consul.zip https://releases.hashicorp.com/consul/0.5.0/consul_0.5.0_linux_${arch}.zip; do
    sleep 60
  done
  unzip consul.zip
  mv consul /usr/local/bin/consul
  rm -f consul.zip
EOS
