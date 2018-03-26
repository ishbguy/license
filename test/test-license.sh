#!/usr/bin/env bash

declare -gr LICENSE_TEST_ABS_DIR=$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd)

source $LICENSE_TEST_ABS_DIR/../license.sh
import $LICENSE_TEST_ABS_DIR/../baux/lib/unit.sh

mkdir -p test-license && trap 'rm -rf test-license' EXIT SIGKILL SIGINT \
    || die "Can not mkdir."

(license -h)
(license -v)
(license mit)
(license -o test-license/test-mit mit)
(license -n TEST -y xxxx mit)
(license -d test-license -u)
(license -d test-license -l)
