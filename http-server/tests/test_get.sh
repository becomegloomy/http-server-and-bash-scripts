#!/bin/bash
set -e
./http_server &
PID=$!
sleep 0.5
CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:1111/)
kill $PID 2>/dev/null || true
[ "$CODE" = "200" ] && echo "GET OK" || { echo "GET FAIL: $CODE"; exit 1; }
