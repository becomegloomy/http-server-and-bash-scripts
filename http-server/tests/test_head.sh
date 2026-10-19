#!/bin/bash
set -e
./http_server &
PID=$!
sleep 0.5
OUT=$(curl -s -I http://localhost:1111/ | head -1)
kill $PID 2>/dev/null || true
echo "$OUT" | grep -q "200 OK" && echo "HEAD OK" || { echo "HEAD FAIL: $OUT"; exit 1; }
