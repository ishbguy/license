#!/usr/bin/env bash

declare -gr LICENSE_TEST_ABS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$LICENSE_TEST_ABS_DIR/../license.sh"
import "$LICENSE_TEST_ABS_DIR/../baux/lib/test.sh"

mkdir -p test-license || die "Can not mkdir."
trap 'rm -rf test-license' EXIT SIGINT

run_ok '$status -eq 1 && $output == "Please give a license."' license
run_ok '$status -eq 0' license -h
run_ok '$status -eq 0' license -v
run_ok '$status -eq 1 && $output =~ "not a directory"' license -d dir -l
run_ok '$status -eq 0' license -d test-license -u
run_ok '$status -eq 0 && $(echo $output | wc -l) -gt 0' license -d test-license -l
run_ok '$status -eq 0' license -d test-license mit
run_ok '$status -eq 0' license -d test-license gpl-3.0
run_ok '$status -eq 0 && $output =~ "XXXXXX"' license -d test-license -n XXXXXX mit
run_ok '$status -eq 0 && $output =~ "XXXXXX"' license -d test-license -y XXXXXX mit
run_ok '$status -eq 0 && -s test-license/test-mit' license -d test-license -o test-license/test-mit mit
run_ok '$status -eq 1 && $output =~ "already exists"' license -d test-license -o test-license/test-mit mit

summary
