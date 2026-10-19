#!/bin/bash
set -e

rm -rf /tmp/src /tmp/dst

mkdir -p /tmp/src
echo "a" > /tmp/src/a.txt
echo "b" > /tmp/src/b.txt

echo "setup OK"
