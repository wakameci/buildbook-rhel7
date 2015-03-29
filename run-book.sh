#!/bin/bash
#
# requires:
#  bash
#
# usage:
#  # run-book.sh <book-name>
#  # run-book.sh <book-name> <book-name> <book-name> ...
#
#  # CHROOT_DIR=/               run-book.sh <book-name>
#  # CHROOT_DIR=/path/to/chroot run-book.sh <book-name>
#

### functions

function run_xexecscripts() {
  local chroot_dir=$1; shift
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  while [[ $# -ne 0 ]]; do
    run_xexecscript ${chroot_dir} $1
    shift
  done
}

function run_xexecscript() {
  local chroot_dir=$1 xexecscript=$2
  [[ -d "${chroot_dir}"  ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -n "${xexecscript}" ]] || return 0
  [[ -x "${xexecscript}" ]] || { echo "[WARN] cannot execute script: ${xexecscript} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 0; }

  printf "[INFO] Excecuting script: %s\n" ${xexecscript}

  (. ${xexecscript} ${chroot_dir}) || {
    echo "[ERROR] xexecscript failed: exitcode=$? (${BASH_SOURCE[0]##*/}:${LINENO})" >&2
    return 1
  }
}

function run_copy() {
  local chroot_dir=$1 copy=$2
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -n "${copy}" ]] || return 0
  [[ -f "${copy}" ]] || { echo "[ERROR] The path to the copy directive is invalid: ${copy}. Make sure you are providing a full path. (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  (
  printf "[INFO] Copying files specified by copy in: %s\n" ${copy}
  cd ${copy%/*}
  while read line; do
    set ${line}
    [[ $# -ge 2 ]] || continue
    local destdir=${chroot_dir}${2%/*}
    [[ -d "${destdir}" ]] || mkdir -p ${destdir}
    local srcpath=${1} dstpath=${chroot_dir}${2}
    # keep symlink
    # $ rsync -aHA ${1} ${chroot_dir}${2} || :
    # don't keep symlink
    # $ cp -LpR ${1} ${chroot_dir}${2}
    local mode=
    (
      # 1. src dst [options]
      # 2. [options]
      shift 2
      # eval [options]
      eval "$@"

      # keep original file mode
      [[ -n "${mode}" ]] || mode=$(stat -c %a ${srcpath})
      install -p --mode ${mode} --owner ${owner:-root} --group ${group:-root} ${srcpath} ${dstpath}
    )
  done < <(egrep -v '^$|^#' ${copy##*/})
  )
}

function run_copies() {
  local chroot_dir=$1; shift
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  while [[ $# -ne 0 ]]; do
    run_copy ${chroot_dir} $1
    shift
  done
}

function run_book() {
  local chroot_dir=$1 name=$2
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }
  [[ -d "${name}" ]] || { echo "[ERROR] directory not found: ${name} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  local xexecscript="$(find -L ${name} ! -type d -perm -a=x         | sort)"
  local        copy="$(find -L ${name} ! -type d -name copy.txt     | sort)"
  local    postcopy="$(find -L ${name} ! -type d -name postcopy.txt | sort)"

  cat <<-EOS | sed 's,^,# ,'
	       copy: $(echo ${copy})
	   postcopy: $(echo ${postcopy})
	xexecscript: $(echo ${xexecscript})
	EOS

  run_copies       ${chroot_dir} ${copy}
  run_xexecscripts ${chroot_dir} ${xexecscript}
  run_copies       ${chroot_dir} ${postcopy}
}

function run_books() {
  local chroot_dir=$1; shift
  [[ -d "${chroot_dir}" ]] || { echo "[ERROR] directory not found: ${chroot_dir} (${BASH_SOURCE[0]##*/}:${LINENO})" >&2; return 1; }

  while [[ $# -ne 0 ]]; do
    run_book ${chroot_dir} $1
    shift
  done
}

### main

set -e
set -o pipefail

declare abs_dirname=${BASH_SOURCE[0]%/*}/
cd ${abs_dirname}

run_books ${CHROOT_DIR:-"/"} "${@}"
