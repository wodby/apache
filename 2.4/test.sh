#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

name=$1
image=$2

cid="$(docker run -d --name "${name}" "${image}")"
trap "docker rm -vf $cid > /dev/null" EXIT

apache() {
	docker run --rm -i --link "${name}":"apache" "${image}" "$@" host="apache"
}

apache make check-ready wait_seconds=1 max_try=10
apache curl -s "apache"
