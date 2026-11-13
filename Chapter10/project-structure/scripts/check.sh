#!/usr/bin/env bash
set -euo pipefail

for preset in x86 stm32f072 stm32f407; do
    cmake --workflow --preset "$preset"
done