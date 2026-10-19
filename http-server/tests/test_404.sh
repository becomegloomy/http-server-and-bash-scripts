#!/bin/bash
set -e
./http_server &
PID=$!
sleep 0.5
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:1111/nope)
kill $PID 2>/dev/null || true
[ "$CODE" = "404" ] && echo "404 OK" || { echo "404 FAIL: $CODE"; exit 1; }
