#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

# https://access.redhat.com/site/documentation/ja-JP/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sec-Using_Yum_Variables.html

if [[ -z "${distro_ver}" ]] && [[ -e ${chroot_dir}/etc/centos-release ]]; then
  distro_ver=$(
   sed \
    -e '/^CentOS /!d' \
    -e 's/CentOS.*\srelease\s*\([0-9][0-9.]*\)\s.*/\1/' \
    < ${chroot_dir}/etc/centos-release
  )
fi

if [[ -n "${distro_ver}" ]]; then
  mkdir -p             ${chroot_dir}/etc/yum/vars

  echo ${distro_ver%%.*} > ${chroot_dir}/etc/yum/vars/releasever
  cat                      ${chroot_dir}/etc/yum/vars/releasever
fi
