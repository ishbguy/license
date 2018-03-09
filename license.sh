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
    for NEED in "$@"; do
        which "${NEED}" >/dev/null 2>&1 || die "You need to install ${NEED}"
    done
}

function check_arg()
{
    local EXPECT="$1"
    local ACTUAL="$2"
    local MESSAGE="$3"

    [[ $# -lt 2 ]] && die "${FUNCNAME[0]}() args error."
    
    [[ -n $MESSAGE ]] && MESSAGE=": ${MESSAGE}"
    [[ "${EXPECT}" != "${ACTUAL}" ]] && die "${FUNCNAME[1]}() args error${MESSAGE}."
}

# echo a message with color
function cecho()
{
    check_arg 2 $# "Need a COLOR name and a MESSAGE"

    local COLOR_NAME="$1"
    local MESSAGE="$2"
    local COLOR=

    case "${COLOR_NAME}" in
        bla|black)  COLOR="[30m" ;;
        re|red)     COLOR="[31m" ;;
        gr|green)   COLOR="[32m" ;;
        ye|yellow)  COLOR="[33m" ;;
        blu|blue)   COLOR="[34m" ;;
        ma|magenta) COLOR="[35m" ;;
        cy|cyan)    COLOR="[36m" ;;
        wh|white)   COLOR="[37m" ;;
    esac
    echo -ne "${COLOR}${MESSAGE}[0m"
}

function download_licenses()
{
    check_arg 2 $# "Need a github licenses API URL and license directory"

    local API="$1"
    local DIR="$2"

    for URL in $(curl "${API}" 2>/dev/null | jq -r '.[].url'); do
        LICENSE=$(basename "${URL}")
        # get licenses in backgroup and wait jobs finish
        curl "${URL}" 2>/dev/null | jq -r '.body' >"${DIR}/${LICENSE}" &
    done 2>/dev/null
    wait 2>/dev/null
}

function list_licenses()
{
    check_arg 1 $# "Need a license directory"

    local LICENSE_DIR="$1"
    
    for LIC in $(ls -1 "${LICENSE_DIR}"); do
        # get license's title
        echo "$(cecho blue "${LIC}"): $(head -1 "${LICENSE_DIR}/${LIC}")"
    done
}

API_URL="https://api.github.com/licenses"
PREQUEST_BIN=(curl jq sed)
LICENSE_DIR=${HOME}/.license
NAME=${USER}
YEAR=$(date +%Y)
NEED_LICENSE=
OUT_LICENSE=LICENSE
PROGRAM=$(basename "$0")
VERSION="v0.0.1"
HELP="\
${PROGRAM} [-o|n|y|d|l|v|h] [string] license_name

    -o  Use the string as the output name.
    -n  Use the string as the author name.
    -y  Use the string as the year of the license.
    -d  Use the string as the default license directory.
    -l  List all available licenses.
    -v  Print the version number.
    -h  Print this help message.

${PROGRAM} ${VERSION} is released under the terms of the MIT License.
"

check_bin "${PREQUEST_BIN[@]}"

OPTIND=1
while getopts "o:n:y:d:lvh" OPTION; do
    case ${OPTION} in
        o) OUT_LICENSE=${OPTARG} ;;
        n) NAME=${OPTARG} ;;
        y) YEAR=${OPTARG} ;;
        d) LICENSE_DIR=${OPTARG} ;;
        l) list_licenses "${LICENSE_DIR}" ; exit 0 ;;
        v) echo "${PROGRAM}" ${VERSION} ; exit 0 ;;
        h) echo -ne "${HELP}" ; exit 0 ;;
        ?) echo -ne "${HELP}" ; exit 2 ;;
    esac
done
shift $((OPTIND - 1))

[[ $# -ne 1 ]] && die "Please give a license."
NEED_LICENSE=$1

[[ -d ${LICENSE_DIR} ]] || mkdir -p "${LICENSE_DIR}" || die "Can not create LICENSE_DIR."

# ensure that there is a needed license or die
[[ -e ${LICENSE_DIR}/${NEED_LICENSE} ]] || download_licenses "${API_URL}" "${LICENSE_DIR}"
[[ -e ${LICENSE_DIR}/${NEED_LICENSE} ]] || die "Can not download ${NEED_LICENSE}."

cp "${LICENSE_DIR}/${NEED_LICENSE}" "${OUT_LICENSE}"

# substitute with year and user name.
if [[ ${NEED_LICENSE} == "mit" ||\
    ${NEED_LICENSE} == "bsd-2-clause" ||\
    ${NEED_LICENSE} == "bsd-3-clause" ]]; then
    sed -ri -e "s/\\[year\\]/${YEAR}/;s/\\[fullname\\]/${NAME}/" "${OUT_LICENSE}"
fi

# vim:ft=sh:ts=4:sw=4
