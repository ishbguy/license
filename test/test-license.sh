#!/usr/bin/env bash

#! /usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

# source guard
[[ $TEST_LICENSE_SOURCED -eq 1 ]] && return
declare -gr TEST_LICENSE_SOURCED=1
declare -gr TEST_LICENSE_ABS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$TEST_LICENSE_ABS_DIR/../license.sh"
import "$TEST_LICENSE_ABS_DIR/../baux/lib/test.sh"

test_license() {
    mkdir -p test-license || die "Can not mkdir."
    trap 'rm -rf test-license' RETURN EXIT SIGINT

    run_ok '$status -eq 1 && $output == "Please give a license."' license
    run_ok '$status -eq 0' license -h
    run_ok '$status -eq 0' license -v
    run_ok '$status -eq 0 && $output =~ "choosealicense"' license -c
    run_ok '$status -eq 1 && $output =~ "not a directory"' license -d dir -l
    run_ok '$status -eq 0' license -d test-license -u
    run_ok '$status -eq 0 && $(echo $output | wc -l) -gt 0' license -d test-license -l
    run_ok '$status -eq 0' license -d test-license mit
    run_ok '$status -eq 0' license -d test-license gpl-3.0
    run_ok '$status -eq 0 && $output =~ "XXXXXX"' license -d test-license -n XXXXXX mit
    run_ok '$status -eq 0 && $output =~ "XXXXXX"' license -d test-license -y XXXXXX mit
    run_ok '$status -eq 0 && -s test-license/test-mit' license -d test-license -o test-license/test-mit mit
    run_ok '$status -eq 1 && $output =~ "already exists"' license -d test-license -o test-license/test-mit mit
}

[[ ${FUNCNAME[0]} == "main" ]] \
    && test_license "$@" && summary

# vim:set ft=sh ts=4 sw=4:
