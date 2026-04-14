#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCREEN_DIR="$ROOT_DIR/mission/screenshots"
README_PATH="$ROOT_DIR/README.md"
LOG_PATH="$ROOT_DIR/mission/evidence/terminal.log"

missing=0

echo "[check] base files"
for f in "$README_PATH" "$LOG_PATH" "$ROOT_DIR/mission/Dockerfile" "$ROOT_DIR/mission/app/index.html"; do
  if [[ -f "$f" ]]; then
    echo "  ok: $f"
  else
    echo "  missing: $f"
    missing=1
  fi
done

echo "[check] screenshot evidence"
for s in \
  "$SCREEN_DIR/web-8080.png" \
  "$SCREEN_DIR/web-8081.png" \
  "$SCREEN_DIR/web-8090.png" \
  "$SCREEN_DIR/vscode-github-login.png"
do
  if [[ -f "$s" ]]; then
    echo "  ok: $s"
  else
    echo "  missing: $s"
    missing=1
  fi
done

echo "[check] key log markers"
for q in \
  "docker --version" \
  "docker info" \
  "docker run --name hw-test hello-world" \
  "docker run -dit --name ubuntu-lab ubuntu bash" \
  "docker build -t mission-web:1.0 ." \
  "curl -i http://localhost:8080" \
  "curl -i http://localhost:8081" \
  "docker volume create mission_data" \
  "git config --list" \
  "git push"
do
  if grep -q "$q" "$LOG_PATH"; then
    echo "  ok: $q"
  else
    echo "  missing in log: $q"
    missing=1
  fi
done

echo "[result]"
if [[ "$missing" -eq 0 ]]; then
  echo "  PASS: submission appears complete"
else
  echo "  ACTION NEEDED: some required evidence is still missing"
  exit 2
fi
