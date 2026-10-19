#!/bin/bash
set -e
cd "$(dirname "$0")/.."

./tests/test_get.sh
sleep 1
./tests/test_head.sh
sleep 1
./tests/test_404.sh

echo "All tests passed"
