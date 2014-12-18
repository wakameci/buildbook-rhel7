#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

chroot $1 $SHELL -ex <<'EOS'
  # WARNING: Module python-magic is not available. Guessing MIME types based on file extensions.
  yum install --disablerepo=updates -y python-magic

  yum install --disablerepo=updates --enablerepo=epel-testing -y s3cmd
EOS
