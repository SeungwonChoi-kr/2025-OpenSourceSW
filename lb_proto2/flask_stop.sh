#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$SCRIPT_DIR/flask_pids.txt"

echo "== Flask 서버 종료 =="

if [ ! -f "$PID_FILE" ]; then
  echo "  - PID 파일이 없습니다. 이미 종료되었거나 실행된 적이 없습니다."
  exit 0
fi

while read -r PID; do
  if [ -n "$PID" ]; then
    if ps -p "$PID" >/dev/null 2>&1; then
      echo "  - PID ${PID} 종료"
      kill "$PID" || true
    fi
  fi
done < "$PID_FILE"

rm -f "$PID_FILE"

echo "✅ 완료: Flask 프로세스 종료됨."
