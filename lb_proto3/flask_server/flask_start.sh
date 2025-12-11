#!/usr/bin/env bash
set -euo pipefail

# 이 스크립트가 있는 디렉터리 기준으로 실행
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

APP_FILE="app.py"                 # 플라스크 서버 코드 파일명
PID_FILE="$SCRIPT_DIR/flask_pids.txt"

START_PORT=5001                   # 시작 포트
END_PORT=5005                     # 끝 포트 (5001~5005 총 5개)

echo "== Flask 서버 시작 =="
echo "  - 스크립트 위치: $SCRIPT_DIR"
echo "  - 사용 파일    : $APP_FILE"
echo "  - 포트 범위    : ${START_PORT} ~ ${END_PORT}"
echo "  - PID 파일     : $PID_FILE"
echo "  - 가정: 이미 venv가 활성화되어 있고, 'python'이 venv의 파이썬을 가리킴"
echo

# 기존 PID 파일이 있으면 경고만 출력 (자동 종료는 하지 않음)
if [ -f "$PID_FILE" ]; then
  echo "⚠️  기존 PID 파일이 존재합니다: $PID_FILE"
  echo "   이전에 실행된 서버를 종료하지 않았다면, ./flask_stop.sh 를 먼저 실행하세요."
fi

# 새 PID 파일 생성(내용 비우기)
: > "$PID_FILE"

PYTHON_BIN="python"
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN="python3"
fi

for PORT in $(seq "$START_PORT" "$END_PORT"); do
  echo "  - FLASK_PORT=${PORT} 서버를 백그라운드로 실행합니다..."

  # 로그는 성능 때문에 버림
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
