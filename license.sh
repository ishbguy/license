#! /usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

#set -x

function die()
{
    echo "$@"
    exit 1
}

function check_tool()
{
    for TOOL in "$@"; do
        which "${TOOL}" >/dev/null 2>&1 \
            || die "You need to install ${TOOL}"
    done
}

function ensure()
{
    local EXPECT="$1"
    local ACTUAL="$2"
    local MESSAGE="$3"

    [[ $# -lt 2 ]] && die "${FUNCNAME[0]}() args error."
    
    [[ -n $MESSAGE ]] && MESSAGE=": ${MESSAGE}"
    [[ "${EXPECT}" != "${ACTUAL}" ]] \
        && die "${FUNCNAME[1]}() args error${MESSAGE}."
}

# echo a message with color
function cecho()
{
    ensure 2 $# "Need a COLOR name and a MESSAGE"

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
        *)          COLOR="[34m" ;;
    esac
    echo -ne "${COLOR}${MESSAGE}[0m"
}

function read_config()
{
    ensure 2 $# "Need LICENSE_CONFIGS array and CONFIG_FILE"

    # make a ref of config array
    local -n CONFIGS="$1"
    local CONFIG_FILE="$2"
    local OLD_IFS="${IFS}"
    local TMP_FILE

    [[ -e ${CONFIG_FILE} ]] || return 1

    # remove blank lines, comments, heading and tailing spaces
    TMP_FILE=$(mktemp)
    sed -re '/^\s*$/d;/^#.*/d;s/#.*//g;s/^\s+//;s/\s+$//' \
        "${CONFIG_FILE}" >"${TMP_FILE}"

    # read name-value pairs from config file
    while IFS="=" read -r NAME VALUE; do
        NAME="${NAME#\"}"; NAME="${NAME%\"}"
        VALUE="${VALUE#\"}"; VALUE="${VALUE%\"}"
        CONFIGS["${NAME,,}"]="${VALUE}"
    done <"${TMP_FILE}"

    rm -rf "${TMP_FILE}"
    IFS="${OLD_IFS}"
}

function download_licenses()
{
    ensure 2 $# "Need a github licenses API URL and license directory"

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
    ensure 1 $# "Need a license directory"

    local LICENSE_DIR="$1"
    
    for LICENSE in $(basename -a "${LICENSE_DIR}"/*); do
        # get license's title
        echo "$(cecho blue "${LICENSE}"): $(head -1 "${LICENSE_DIR}/${LICENSE}")"
    done
}

LICENSE_CONFIG_FILE="${HOME}/.licenserc"
declare -A LICENSE_CONFIGS
[[ -e ${LICENSE_CONFIG_FILE} ]] \
    && read_config LICENSE_CONFIGS "${LICENSE_CONFIG_FILE}"
GITHUB_LICENSES_API="https://api.github.com/licenses"
PREREQUSITE_TOOLS=(curl jq sed)
LICENSE_DIR="${LICENSE_CONFIGS[license_dir]:-${HOME}/.license}"
AUTHOR="${LICENSE_CONFIGS[author]:-${USER}}"
YEAR=$(date +%Y)
TARGET_LICENSE=
LICENSE_NAME="${LICENSE_CONFIGS[license_name]:-LICENSE}"
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

check_tool "${PREREQUSITE_TOOLS[@]}"

OPTIND=1
while getopts "o:n:y:d:lvh" OPTION; do
    case ${OPTION} in
        o) LICENSE_NAME=${OPTARG} ;;
        n) AUTHOR=${OPTARG} ;;
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
TARGET_LICENSE="$1"

[[ -d ${LICENSE_DIR} ]] || mkdir -p "${LICENSE_DIR}" \
    || die "Can not create LICENSE_DIR."

# ensure that there is a needed license or die
[[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
    || download_licenses "${GITHUB_LICENSES_API}" "${LICENSE_DIR}"
[[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
    || die "Can not download ${TARGET_LICENSE}."

cp "${LICENSE_DIR}/${TARGET_LICENSE}" "${LICENSE_NAME}"

# substitute with year and user name.
if [[ ${TARGET_LICENSE} == "mit" ||\
    ${TARGET_LICENSE} == "bsd-2-clause" ||\
    ${TARGET_LICENSE} == "bsd-3-clause" ]]; then
    sed -ri -e "s/\\[year\\]/${YEAR}/;s/\\[fullname\\]/${AUTHOR}/" \
        "${LICENSE_NAME}"
fi

# vim:ft=sh:ts=4:sw=4
