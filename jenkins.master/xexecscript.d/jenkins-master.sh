#!/bin/bash
#
# requires:
#  bash
#
set -e

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  curl -fSkL http://pkg.jenkins-ci.org/redhat/jenkins.repo -o /etc/yum.repos.d/jenkins.repo
  rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key

  yum install --disablerepo=updates -y jenkins
  # in order to draw graphs/charts
  yum install --disablerepo=updates -y dejavu-sans-fonts

  # prevent jenkins starting
  chkconfig --list jenkins
  chkconfig jenkins off
  chkconfig --list jenkins
EOS
