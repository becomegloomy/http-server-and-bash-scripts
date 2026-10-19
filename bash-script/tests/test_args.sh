#!/bin/bash
set -e
cd "$(dirname "$0")/.."

if ./script.sh 2>/dev/null; then
    echo "args FAIL: should fail without args"
    exit 1
fi

if ./script.sh a b c 2>/dev/null; then
    echo "args FAIL: should fail with 3 args"
    exit 1
fi

echo "args OK"
