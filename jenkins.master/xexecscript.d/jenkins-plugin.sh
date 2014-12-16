#!/bin/bash
#
# requires:
#  bash
#
set -e

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
    curl -fSkL ${base_url}/${version}/${name}.hpi -o /var/lib/jenkins/plugins/${name}.hpi
  done < <(cat <<-_EOS_ | egrep -v '^#|^$'
	PrioritySorter 1.3
	config-autorefresh-plugin
	configurationslicing
	config-file-provider
	cron_column
	downstream-buildview
	git        1.4.0
	git-client 1.1.1
	hipchat 0.1.5
	greenballs
	managed-scripts 1.1
	nested-view
	next-executions
	parameterized-trigger 2.18
	rebuild 1.20
	timestamper 1.5.6
	token-macro
	urltrigger
	view-job-filters
	_EOS_
	)

  chown -R jenkins:jenkins /var/lib/jenkins/plugins
EOS
