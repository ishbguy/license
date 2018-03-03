#! /usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

#set -x

function die()
{
    echo "$@"
    exit 1
}

function check_bin()
{
    for NEED in $@; do
        which ${NEED} 2>&1 >/dev/null || die "You need to install ${NEED}"
    done
}

function check_arg()
{
    local EXPECT=$1
    local ACTUAL=$2

    [[ $# -ne 2 ]] && die "${FUNCNAME[0]}() args error."
    [[ ${EXPECT} -ne ${ACTUAL} ]] && die "${FUNCNAME[1]}() args error."
}

function download_licenses()
{
    check_arg 2 $#

    local API=$1
    local DIR=$2

    for URL in $(curl ${API} 2>/dev/null | jq .[].url); do
        URL=$(echo ${URL} | sed -r -e 's/^"//;s/"$//')
        LICENSE=$(basename $URL)
        echo -ne $(curl ${URL} 2>/dev/null | jq .body | sed -r -e 's/^"//;s/"$//;s/\\\"/"/g') >${DIR}/${LICENSE}
    done
}

API_URL="https://api.github.com/licenses"
PREQUEST_BIN=(curl jq sed)
LICENSE_DIR=${HOME}/.license
NAME=${USER}
YEAR=$(date +%Y)
NEED_LICENSE=
OUT_LICENSE=LICENSE
PROGRAM=$(basename $0)
VERSION="v0.0.1"
HELP="
${PROGRAM} [-o|n|y|d|l|v|h] [string] license_name\n
    -o  Use the string as the output name.\n
    -n  Use the string as the author name.\n
    -y  Use the string as the year of the license.\n
    -d  Use the string as the default license directory.\n
    -l  List all available licenses.\n
    -v  Print the version number.\n
    -h  Print this help message.\n\n

${PROGRAM} ${VERSION} is released under the terms of the MIT License.\n
"

check_bin ${PREQUEST_BIN[@]}

OPTIND=1
while getopts "o:n:y:d:lvh" OPTION; do
    case ${OPTION} in
        o) OUT_LICENSE=${OPTARG} ;;
        n) NAME=${OPTARG} ;;
        y) YEAR=${OPTARG} ;;
        d) LICENSE_DIR=${OPTARG} ;;
        l) ls -1 ${LICENSE_DIR} ; exit 0 ;;
        v) echo ${PROGRAM} ${VERSION} ; exit 0 ;;
        h) echo -ne ${HELP} ; exit 0 ;;
        ?) echo -ne ${HELP} ; exit 2 ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ne 1 ]] && die "Please give a license."
NEED_LICENSE=$1

[[ -d ${LICENSE_DIR} ]] || mkdir -p ${LICENSE_DIR} || die "Can not create LICENSE_DIR."

[[ -e ${LICENSE_DIR}/${NEED_LICENSE} ]] || download_licenses ${API_URL} ${LICENSE_DIR}

cp ${LICENSE_DIR}/${NEED_LICENSE} ${OUT_LICENSE}

if [[ ${NEED_LICENSE} == "mit" ]]; then
    sed -ri -e "s/\[year\]/${YEAR}/;s/\[fullname\]/${NAME}/" ${OUT_LICENSE}
fi

# vim:ft=sh:ts=4:sw=4
