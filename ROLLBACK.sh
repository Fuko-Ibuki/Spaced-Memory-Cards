#!/bin/sh
set -eu
# Usage: ./ROLLBACK.sh TARGET BASELINE_COPY
cp "$2" "$1"
