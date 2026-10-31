#!/bin/sh
set -eu
TARGET=${1:-style.css}
cp MODIFIED_FILE "$TARGET"
printf '%s\n' "rollback restored $TARGET from MODIFIED_FILE snapshot"
