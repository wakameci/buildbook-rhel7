#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail

declare chroot_dir=$1

chroot $1 $SHELL -ex <<'EOS'
  [[ -d /var/lib/jenkins/plugins ]] || mkdir -p /var/lib/jenkins/plugins
  # install git plugin
  base_url=http://updates.jenkins-ci.org
  while read line; do
    set ${line}
    name=${1} version=${2}
    if [[ -z "${version}" ]]; then
      version=latest
    else
      version=download/plugins/${name}/${version}
    fi
    [[ -f /var/lib/jenkins/plugins/${name}.hpi ]] && continue
    curl -fSkLR ${base_url}/${version}/${name}.hpi -o /var/lib/jenkins/plugins/${name}.hpi
  done < <(cat <<-_EOS_ | egrep -v '^#|^$'
	PrioritySorter
	ci-skip
	config-autorefresh-plugin
	config-file-provider
	configurationslicing
	cron_column
	downstream-buildview
	git        1.4.0
	git-client 1.1.1
	github-api
	github-oauth
	greenballs
	hipchat
	managed-scripts
	nested-view
	next-executions
	parameterized-trigger
	rbenvrbenv
	rebuild
	ruby-runtime
	timestamper
	throttle-concurrents
	token-macro
	urltrigger
	view-job-filters
	_EOS_
	)

  chown -R jenkins:jenkins /var/lib/jenkins/plugins
EOS
