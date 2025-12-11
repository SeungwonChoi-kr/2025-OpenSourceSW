#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

APP_FILE="nginx_test_flask_code.py"
PID_FILE="$SCRIPT_DIR/flask_pids.txt"

START_PORT=5001
END_PORT=5005

echo "== Flask 서버들을 시작합니다 =="
echo "  - 로그 저장 없음"
echo "  - PID 파일: $PID_FILE"
echo

# 기존 PID 파일이 있으면 경고
if [ -f "$PID_FILE" ]; then
  echo "⚠️  기존 PID 파일이 존재합니다: $PID_FILE"
  echo "   기존 서버가 실행 중일 수 있으니 ./flask_stop.sh 먼저 실행하세요."
fi

# 새로운 PID 파일 생성
: > "$PID_FILE"

PYTHON_BIN="python"
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN="python3"
fi

# 포트별 Flask 실행
for PORT in $(seq "$START_PORT" "$END_PORT"); do
  echo "  - FLASK_PORT=${PORT} 서버를 백그라운드로 실행합니다..."

  FLASK_PORT="$PORT" nohup "$PYTHON_BIN" "$APP_FILE" \
    > /dev/null 2>&1 &

  PID=$!
  echo "    → PID=${PID}"
  echo "$PID" >> "$PID_FILE"
done

echo
echo "✅ Flask 서버들이 모두 실행되었습니다!"
echo " - 포트 범위: ${START_PORT} ~ ${END_PORT}"
echo " - PID 목록: $PID_FILE"
echo
echo "➡ 예시 테스트:"
echo "  curl http://localhost:5001/add"
