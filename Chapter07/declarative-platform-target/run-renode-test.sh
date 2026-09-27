#!/usr/bin/env bash

set -euo pipefail

robot_file="$1"
firmware="$2"

exec renode-test \
    --variable "ELF:${firmware}" \
    "${robot_file}"