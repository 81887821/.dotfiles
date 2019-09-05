#!/bin/bash

function error() {
    echo "$@" 1>&2
}

function die() {
    error "$@"
    exit 1
}
