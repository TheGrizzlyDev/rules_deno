#!/bin/bash

set -euo pipefail

program="$1"
got=$("$program")
want="$2"

if [ "$got" != "$want" ]; then
  cat >&2 <<EOF
got:
$got

expected:
$want
EOF
  exit 1
fi