#!/bin/bash
set -e
cd "$(dirname "$0")/.."
./tests/test_get.sh
./tests/test_head.sh
./tests/test_404.sh
echo "All tests passed"
