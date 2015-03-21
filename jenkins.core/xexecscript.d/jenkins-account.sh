#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

# jenkins:x:498:497:Jenkins Continuous Build server:/var/lib/jenkins:/bin/bash
# jenkins:x:497

chroot $1 $SHELL -ex <<'EOS'
  getent group  jenkins >/dev/null || groupadd -r jenkins
  getent passwd jenkins >/dev/null || useradd -g jenkins -d /var/lib/jenkins -s /bin/bash -r -m jenkins
  usermod -s /bin/bash jenkins

  getent group  jenkins
  getent passwd jenkins
EOS

function configure_sudo_sudoers() {
  local chroot_dir=$1 user_name=$2 tag_specs=${3:-"NOPASSWD:"}
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -n "${user_name}"  ]] || { echo "[ERROR] Invalid argument: user_name:${user_name} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  #
  # Tag_Spec ::= ('NOPASSWD:' | 'PASSWD:' | 'NOEXEC:' | 'EXEC:' |
  #               'SETENV:' | 'NOSETENV:' | 'LOG_INPUT:' | 'NOLOG_INPUT:' |
  #               'LOG_OUTPUT:' | 'NOLOG_OUTPUT:')
  #
  # **don't forget suffix ":" to tag_specs.**
  #
  egrep ^${user_name} -w ${chroot_dir}/etc/sudoers || { echo "${user_name} ALL=(ALL) ${tag_specs} ALL" >> ${chroot_dir}/etc/sudoers; }
}

configure_sudo_sudoers $1 jenkins NOPASSWD:
