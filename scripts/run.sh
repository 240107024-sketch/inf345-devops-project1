#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

javac src/Main.java
java -cp src Main