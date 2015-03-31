#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

function baseurl() {
  local releasever=${1}

  local baseurl=http://vault.centos.org

  case "${releasever}" in
    7.0.1406 | 7.1.1503 )
      baseurl=http://ftp.jaist.ac.jp/pub/Linux/CentOS
      ;;
  esac

  echo ${baseurl}
}

if [[ -f ${chroot_dir}/etc/yum/vars/releasever ]]; then
  releasever=$(< ${chroot_dir}/etc/yum/vars/releasever)
  majorver=${releasever%%.*}

  mv ${chroot_dir}/etc/yum.repos.d/CentOS-Base.repo{,.saved}

  baseurl=$(baseurl ${releasever})

  cat <<-REPO > ${chroot_dir}/etc/yum.repos.d/CentOS-Base.repo
	[base]
	name=CentOS-\$releasever - Base
	baseurl=${baseurl}/\$releasever/os/\$basearch/
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${majorver}

	[updates]
	name=CentOS-\$releasever - Updates
	baseurl=${baseurl}/\$releasever/updates/\$basearch/
	gpgcheck=1
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${majorver}
	REPO
fi
