#!/bin/bash
set -e
cd "$(dirname "$0")/.."   # в bash-script/

./tests/test_help.sh
./tests/test_args.sh
./tests/test_copy.sh

echo "All tests passed"
