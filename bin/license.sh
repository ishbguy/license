#! /usr/bin/env bash
# Copyright (c) 2018 Herbert Shen <ishbguy@hotmail.com> All Rights Reserved.
# Released under the terms of the MIT License.

#set -x

# source guard
[[ $LICENSE_SOUECED -eq 1 ]] && return
declare -gr LICENSE_SOUECED=1
declare -gr LICENSE_ABS_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

source "$LICENSE_ABS_DIR"/../baux/lib/baux.sh
import "$LICENSE_ABS_DIR"/../baux/lib/utili.sh

LICENSE_CONFIG_FILE="${HOME}/.licenserc"
declare -A LICENSE_CONFIGS
[[ -e ${LICENSE_CONFIG_FILE} ]] \
    && read_config LICENSE_CONFIGS "${LICENSE_CONFIG_FILE}"
PREREQUSITE_TOOLS=(curl jq sed)
LICENSE_DIR="${LICENSE_CONFIGS[license_dir]:-${HOME}/.license}"
AUTHOR="${LICENSE_CONFIGS[author]:-${USER}}"
YEAR=$(date +%Y)
TARGET_LICENSE=
LICENSE_NAME=
LICENSE_JOBS="${LICENSE_CONFIGS[license_jobs]:-8}"
VERSION="v0.1.0"
HELP="\
$(proname) [-o|n|y|d|u|l|v|h] [string] license_name

    -o  Use the string as the output name.
    -n  Use the string as the author name.
    -y  Use the string as the year of the license.
    -d  Use the string as the default license directory.
    -u  Update licenses.
    -l  List all available licenses.
    -c  Show the infomation to choose a license.
    -v  Print the version number.
    -h  Print this help message.

This program is released under the terms of MIT License."

LICENSE_CHOOSE="\
                    Choose an open source license

            $(cecho yellow "{ Which of the following best describes your situation? }")

1. I want it simple and permissive.

    The $(cecho blue "MIT License") is a permissive license that is short and to the point. 
    It lets people do anything they want with your code as long as they provide
    attribution back to you and don't hold you liable.

    Babel, .NET Core, and Rails use the MIT License.

2. I'm concerned about patents.

    The $(cecho blue "Apache License 2.0") is a permissive license similar to the MIT License,
    but also provides an express grant of patent rights from contributors to users.

    Kubernetes, PDF.js, and Swift use the Apache License 2.0.

3. I care about sharing improvements.

    The $(cecho blue "GNU GPLv3") is a copyleft license that requires anyone who distributes your
    code or a derivative work to make the source available under the same terms,
    and also provides an express grant of patent rights from contributors to users.

    Ansible, Bash, and GIMP use the GNU GPLv3.

                $(cecho yellow "{ What if none of these work for me? }")

For more licenses you can find in $(cecho blue "https://choosealicense.com/")"

download_licenses() {
    ensure "$# -eq 1" "Need a directory to save licenses."
    ensure_not_empty "$@"

    local license_dir="$1"
    local license_url="https://api.github.com/licenses"
    local tmp_file="/tmp/license-${FUNCNAME[0]}-${RANDOM}-${RANDOM}-${RANDOM}"

    [[ -d ${license_dir} ]] || mkdir "${license_dir}" || die "Can not mkdir ${license_dir}";

    mkfifo "${tmp_file}"
    exec 8<>"${tmp_file}"
    
    # use trap to clean up when function return
    trap 'exec 8<&-; exec 8>&-; rm -f ${tmp_file}' RETURN

    # fullfill fifo file for later read
    for ((i = 0; i < LICENSE_JOBS; i++)); do
        echo 1>&8
    done

    for url in $(curl "${license_url}" 2>/dev/null | jq -r '.[].url'); do
        read -r -u 8 
        {
            license=$(basename "${url}")
            # get licenses in backgroup and wait jobs finish
            curl "${url}" 2>/dev/null | jq -r '.body' >"${license_dir}/${license}"
            echo 1>&8
        } &
    done 2>/dev/null
    wait 2>/dev/null
}

list_licenses() {
    ensure "$# -eq 1" "Need a license directory"
    ensure_not_empty "$@"

    local license_dir="$1"
    
    [[ -d ${license_dir} ]] || die "${license_dir} is not a directory.";

    for license in $(basename -a "${license_dir}"/*); do
        # get license's title
        echo "$(cecho blue "${license}"): $(head -1 "${license_dir}/${license}" \
            | sed -re 's/^\s+//;s/\s+$//')"
    done
}

choose_license() { echo "$LICENSE_CHOOSE"; }

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
        eval "sed -r -e 's/\\[year\\]/${YEAR}/;s/\\[fullname\\]/${AUTHOR}/' ${LICENSE_DIR}/$lic"
    else
        cat "${LICENSE_DIR}/$lic"
    fi
}

license() {
    check_tool "${PREREQUSITE_TOOLS[@]}"

    # parse options
    declare -A options arguments
    getoptions options arguments "o:n:y:d:ulcvh" "$@"
    shift $((OPTIND - 1))

    # get user specified var
    [[ ${options[o]} -eq 1 ]] && LICENSE_NAME=${arguments[o]}
    [[ ${options[n]} -eq 1 ]] && AUTHOR=${arguments[n]}
    [[ ${options[y]} -eq 1 ]] && YEAR=${arguments[y]}
    [[ ${options[d]} -eq 1 ]] && LICENSE_DIR=${arguments[d]}

    # execute prior task and exit
    [[ ${options[v]} -eq 1 || ${options[h]} -eq 1 ]] && usage && exit 0
    [[ ${options[l]} -eq 1 ]] && list_licenses "${LICENSE_DIR}" && exit 0
    [[ ${options[c]} -eq 1 ]] && choose_license && exit 0
    [[ ${options[u]} -eq 1 ]] \
        && download_licenses "${LICENSE_DIR}" && exit 0

    [[ $# -ne 1 ]] && die "Please give a license."
    TARGET_LICENSE="$1"

    [[ -d ${LICENSE_DIR} ]] \
        || mkdir -p "${LICENSE_DIR}" || die "Can not create ${LICENSE_DIR}."

    # ensure that there is a needed license or die
    [[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
        || download_licenses "${LICENSE_DIR}"
    [[ -e ${LICENSE_DIR}/${TARGET_LICENSE} ]] \
        || die "Can not download ${TARGET_LICENSE}."

    gen_license "${TARGET_LICENSE}" "${LICENSE_NAME}"

    return "$BAUX_EXIT_CODE"
}

[[ ${FUNCNAME[0]} == "main" ]] \
    && license "$@"

# vim:ft=sh:ts=4:sw=4
