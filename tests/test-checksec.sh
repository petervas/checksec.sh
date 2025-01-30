#!/usr/bin/env bash
# run a quick test of checksec.sh to ensure normal operations.
DIR=$(
  cd "$(dirname "$0")" || exit
  pwd
)

"${DIR}"/xml-checks.sh || exit 2
"${DIR}"/json-checks.sh || exit 2
"${DIR}"/hardening-checks.sh || exit 2
