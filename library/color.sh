#!/bin/bash

function try_enable_color() {
    local colors

    if colors=$(tput colors 2>/dev/null); then
        if [ ${colors} -gt 0 ] && tput setaf 0 &>/dev/null; then
            readonly NORMAL="$(tput sgr0)"
            readonly BOLD="$(tput bold)"
            readonly RED="$(tput setaf 1)"
            readonly GREEN="$(tput setaf 2)"
            readonly YELLO="$(tput setaf 3)"
            readonly WHITE="$(tput setaf 7)"
            return
        fi
    fi

    readonly NORMAL=""
    readonly BOLD=""
    readonly RED=""
    readonly GREEN=""
    readonly YELLO=""
    readonly WHITE=""
}

try_enable_color
