#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

PORT="${PORT:-18080}"
export PORT

javac src/Main.java
javac tests/TestRunner.java

java -cp src Main &
SERVER_PID=$!

cleanup() {
    kill "$SERVER_PID" 2>/dev/null || true
}

trap cleanup EXIT

for i in {1..20}; do
    if curl -fsS "http://localhost:$PORT/healthz" >/dev/null 2>&1; then
        break
    fi
    sleep 0.25
done

java -cp tests TestRunner