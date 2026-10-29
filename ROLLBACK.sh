#!/bin/sh
set -eu
TARGET=${1:-style.css}
cp MODIFIED_FILE "$TARGET"
node --check app.js
rg -Fq 'margin:26px auto 30px' "$TARGET"
printf '%s\n' "rollback restored $TARGET from MODIFIED_FILE snapshot"
