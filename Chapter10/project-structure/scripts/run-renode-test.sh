#!/usr/bin/env bash
set -euo pipefail

robot_file="$1"
firmware="$2"
results_dir="${firmware}.results"

mkdir -p "$results_dir"
cd "$results_dir"

exec renode-test \
    --results-dir "$results_dir" \
    --variable "ELF:${firmware}" \
    "$robot_file"