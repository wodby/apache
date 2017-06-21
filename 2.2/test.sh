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
	docker run --rm -i --link "${name}":"apache" "${image}" "$@"
}

apache make check-ready wait_seconds=1 max_try=10 host="apache"

echo -n "Checking version... "
apache httpd -v | grep -q "Server version: Apache\/2.2.*"
echo "OK!"

echo -n "Sending test request... "
apache curl -s apache | grep -q "It works!"
echo "OK!"

