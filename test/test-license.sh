#!/usr/bin/env bash

declare -gr LICENSE_TEST_ABS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$LICENSE_TEST_ABS_DIR/../license.sh"
import "$LICENSE_TEST_ABS_DIR/../baux/lib/unit.sh"

mkdir -p test-license || die "Can not mkdir."
trap 'rm -rf test-license' EXIT SIGINT

(license -h)
(license -v)
(license -d test-license -u)
(license -d test-license -l)
(license -d test-license mit)
(license -o test-license/test-mit mit)
(license -n TEST -y xxxx mit)
