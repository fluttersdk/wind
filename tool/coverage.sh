#!/usr/bin/env bash
set -euo pipefail
flutter test --coverage
PCT=$(lcov --summary coverage/lcov.info 2>&1 | grep 'lines' | grep -o '[0-9.]*%' | head -1 | tr -d '%')
echo "Coverage: ${PCT}%"
if [ -n "${1:-}" ]; then
  THRESHOLD="$1"
  awk -v p="$PCT" -v t="$THRESHOLD" 'BEGIN { exit (p+0 >= t+0) ? 0 : 1 }' \
    || { echo "FAIL: ${PCT}% below threshold ${THRESHOLD}%"; exit 1; }
  echo "PASS: ${PCT}% meets threshold ${THRESHOLD}%"
fi
