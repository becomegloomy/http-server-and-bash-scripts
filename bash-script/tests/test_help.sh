#!/bin/bash
set -e
cd "$(dirname "$0")/.."   

OUTPUT=$(./script.sh --help)
echo "$OUTPUT" | grep -q "Укажите" && echo "help OK" || { echo "help FAIL"; exit 1; }
