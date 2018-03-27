#! /usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

#set -x

# source guard
[[ $LICENSE_SOUECED -eq 1 ]] && return
declare -gr LICENSE_SOUECED=1
declare -gr LICENSE_ABS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$LICENSE_ABS_DIR"/baux/lib/baux.sh
import "$LICENSE_ABS_DIR"/baux/lib/utili.sh

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
LICENSE_NAME=
LICENSE_JOBS="${LICENSE_CONFIGS[license_jobs]:-8}"
VERSION="v0.1.0"
HELP="\
$(proname) [-o|n|y|d|l|v|h] [string] license_name

    -o  Use the string as the output name.
    -n  Use the string as the author name.
    -y  Use the string as the year of the license.
    -d  Use the string as the default license directory.
    -u  Update licenses.
    -l  List all available licenses.
    -v  Print the version number.
    -h  Print this help message.

This program is released under the terms of MIT License."

download_licenses() {
    ensure "2 == $#" "Need a github licenses API URL and license directory"
    ensure_not_empty "$@"

    local API="$1"
    local DIR="$2"
    local TMP_FILE="/tmp/license-${FUNCNAME[0]}-${RANDOM}-${RANDOM}-${RANDOM}"

    [[ -d ${DIR} ]] || mkdir "${DIR}" || die "Can not mkdir ${DIR}";

    mkfifo "${TMP_FILE}"
    exec 8<>"${TMP_FILE}"
    
    # use trap to clean up when function return
    trap 'exec 8<&-; exec 8>&-; rm -f ${TMP_FILE}' RETURN

    # fullfill fifo file for later read
    for ((i = 0; i < LICENSE_JOBS; i++)); do
        echo 1>&8
    done

    for URL in $(curl "${API}" 2>/dev/null | jq -r '.[].url'); do
        read -r -u 8 
        {
            LICENSE=$(basename "${URL}")
            # get licenses in backgroup and wait jobs finish
            curl "${URL}" 2>/dev/null | jq -r '.body' >"${DIR}/${LICENSE}"
            echo 1>&8
        } &
    done 2>/dev/null
    wait 2>/dev/null
}

list_licenses() {
    ensure "1 == $#" "Need a license directory"
    ensure_not_empty "$@"

    local LICENSE_DIR="$1"
    
    [[ -d ${LICENSE_DIR} ]] || die "${LICENSE_DIR} is not a directory.";

    for LICENSE in $(basename -a "${LICENSE_DIR}"/*); do
        # get license's title
        echo "$(cecho blue "${LICENSE}"): $(head -1 "${LICENSE_DIR}/${LICENSE}" \
            | sed -re 's/^\s+//;s/\s+$//')"
    done
}

gen_license() {
    local lic="$1"
    local file="$2"

    if [[ -n $file ]]; then
        [[ -e $file ]] && die "$file already exists."
        # create an empty file
        echo -n >"$file" || die "Fail to create $file."

        # redirect stdout to $file
        exec 3>"$file"
        exec 1>&3
        trap 'exec 3>&1; exec 3>&-' RETURN
    fi

    if [[ ${lic} == "mit" ||\
        ${lic} == "bsd-2-clause" ||\
        ${lic} == "bsd-3-clause" ]]; then
        sed -r 's/\[year\]/'"${YEAR}"'/;s/\[fullname\]/'"${AUTHOR}"'/' \
            "${LICENSE_DIR}/$lic"
    else
        cat "${LICENSE_DIR}/$lic"
    fi
}

license() {
    check_tool "${PREREQUSITE_TOOLS[@]}"

    # parse options
    declare -A OPTIONS ARGUMENTS
    getoptions OPTIONS ARGUMENTS "o:n:y:d:ulvh" "$@"
    shift $((OPTIND - 1))

    # get user specified var
    [[ ${OPTIONS[o]} -eq 1 ]] && LICENSE_NAME=${ARGUMENTS[o]}
    [[ ${OPTIONS[n]} -eq 1 ]] && AUTHOR=${ARGUMENTS[n]}
    [[ ${OPTIONS[y]} -eq 1 ]] && YEAR=${ARGUMENTS[y]}
    [[ ${OPTIONS[d]} -eq 1 ]] && LICENSE_DIR=${ARGUMENTS[d]}

    # execute prior task and exit
    [[ ${OPTIONS[v]} -eq 1 || ${OPTIONS[h]} -eq 1 ]] && usage && exit 0
    [[ ${OPTIONS[l]} -eq 1 ]] && list_licenses "${LICENSE_DIR}" && exit 0
    [[ ${OPTIONS[u]} -eq 1 ]] \
        && download_licenses "${GITHUB_LICENSES_API}" "${LICENSE_DIR}" && exit 0

    [[ $# -ne 1 ]] && die "Please give a license."
    TARGET_LICENSE="$1"

    [[ -d ${LICENSE_DIR} ]] \
        || mkdir -p "${LICENSE_DIR}" || die "Can not create ${LICENSE_DIR}."

    # ensure that there is a needed license or die
    [[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
        || download_licenses "${GITHUB_LICENSES_API}" "${LICENSE_DIR}"
    [[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
        || die "Can not download ${TARGET_LICENSE}."

    gen_license "${TARGET_LICENSE}" "${LICENSE_NAME}"

    return "$BAUX_EXIT_CODE"
}

[[ ${FUNCNAME[0]} == "main" ]] \
    && license "$@"

# vim:ft=sh:ts=4:sw=4
