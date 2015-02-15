#!/bin/bash
#
# requires:
#  bash
#
# links:
#  https://github.com/hashicorp/serf/blob/master/demo/web-load-balancer/setup_serf.sh
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

  until curl -fsSkL -o serf.zip https://dl.bintray.com/mitchellh/serf/0.6.4_linux_${arch}.zip; do
    sleep 1
  done
  unzip serf.zip
  mv serf /usr/local/bin/serf
EOS
