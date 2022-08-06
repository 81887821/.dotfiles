#!/bin/bash

function status() {
    local PREFIX_UP_TO_DATE="${BOLD}[${GREEN}  UpToDate  ${WHITE}]${RESET}"
    local PREFIX_NOT_INSTALLED="${BOLD}[NotInstalled]${RESET}"
    local PREFIX_OUTDATED="${BOLD}[${YELLO}  Outdated  ${WHITE}]${RESET}"
    local PREFIX_MODIFIED="${BOLD}[${YELLO}  Modified  ${WHITE}]${RESET}"
    local PREFIX_ERROR="${BOLD}[${RED}   Error    ${WHITE}]${RESET}"
    local PREFIX_NOT_IMPLEMENTED="${BOLD}[ NotImpled  ]${RESET}"
    local context method packages path

    while IFS=',' read context method packages path; do
        if contains "${context}" "${contexts[@]}"; then
            if ${all_packages} || is_installed "${packages}"; then
                ${method}_state "${path}"
                case $? in
                    "${STATE_UP_TO_DATE}")
                        echo "${PREFIX_UP_TO_DATE} ${path}"
                        ;;
                    "${STATE_NOT_INSTALLED}")
                        echo "${PREFIX_NOT_INSTALLED} ${path}"
                        ;;
                    "${STATE_OUTDATED}")
                        echo "${PREFIX_OUTDATED} ${path}"
                        ;;
                    "${STATE_MODIFIED}")
                        echo "${PREFIX_MODIFIED} ${path}"
                        ;;
                    "${STATE_ERROR}")
                        echo "${PREFIX_ERROR} ${path}"
                        echo "${method}_state returned STATE_ERROR"
                        ;;
                    "${STATE_NOT_IMPLEMENTED}")
                        echo "${PREFIX_NOT_IMPLEMENTED} ${path}"
                        ;;
                    *)
                        echo -e "${PREFIX_ERROR} ${path}\nInvalid state: $?"
                        ;;
                esac
            fi
        fi
    done <<< "$(tail -n+2 "${file_list}")"
}

function status_parse_arguments() {
    parse_arguments "$@"
}
