#!/bin/bash

function install() {
    local PREFIX_OK="${BOLD}[${GREEN}    OK    ${WHITE}]${RESET}"
    local PREFIX_UP_TO_DATE="${BOLD}[${GREEN} UpToDate ${WHITE}]${RESET}"
    local PREFIX_FAILED="${BOLD}[${RED}  Failed  ${WHITE}]${RESET}"
    local PREFIX_MODIFIED="${BOLD}[${YELLO} Modified ${WHITE}]${RESET}"
    local PREFIX_ERROR="${BOLD}[${RED}  Error   ${WHITE}]${RESET}"
    local context method packages path outputs

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                ${method}_state "${path}"
                case $? in
                    "${STATE_UP_TO_DATE}")
                        echo "${PREFIX_UP_TO_DATE} ${path}"
                        ;;
                    "${STATE_NOT_INSTALLED}" | "${STATE_OUTDATED}" | "${STATE_MODIFIED}" | "${STATE_NOT_IMPLEMENTED}")
                        if [ $? -eq "${STATE_MODIFIED}" ] && ! ${overwrite}; then
                            echo "${PREFIX_MODIFIED} ${path}"
                            continue
                        fi

                        if outputs="$(${method}_install "${path}" 2>&1)"; then
                            echo "${PREFIX_OK} ${path}"
                        else
                            echo "${PREFIX_FAILED} ${path}"
                            echo "${outputs}"
                        fi
                        ;;
                    *)
                        echo -e "${PREFIX_ERROR} ${path}\nFailed to get state: $?"
                        ;;
                esac
            fi
        fi
    done <<< "$(tail -n+2 "${file_list}")"
}

function install_parse_arguments() {
    parse_arguments "$@"
}
