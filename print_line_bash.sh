#!/bin/bash

function log() {

    echo "LINENO: ${LINENO}"

    echo "BASH_LINENO: ${BASH_LINENO[0]}"
    echo "BASH_LINENO: ${BASH_LINENO[*]}"
}

log
