#!/bin/bash
set -e
cd "$(dirname "$0")/.."

./tests/setup.sh

./script.sh /tmp/src /tmp/dst > /dev/null

[ -f /tmp/dst/a.txt ] && [ -f /tmp/dst/b.txt ] && echo "copy OK" || { echo "copy FAIL"; exit 1; }
