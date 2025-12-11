#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF_SRC="$SCRIPT_DIR/flask_nginx.conf"

SITE_NAME="flask_multi"
CONF_DST="/etc/nginx/sites-available/${SITE_NAME}"
CONF_LINK="/etc/nginx/sites-enabled/${SITE_NAME}"

echo "== Nginx 설정 적용 =="

if [ ! -f "$CONF_SRC" ]; then
  echo "❌ 오류: Nginx 설정 파일(flask_nginx.conf)을 찾을 수 없습니다."
  exit 1
fi

# nginx 설치 여부 확인
if ! command -v nginx >/dev/null 2>&1; then
  echo "  - nginx 설치 중..."
  sudo apt update
  sudo apt install -y nginx
fi

echo "  - 설정 복사"
sudo cp "$CONF_SRC" "$CONF_DST"

echo "  - sites-enabled 링크 생성"
sudo ln -sf "$CONF_DST" "$CONF_LINK"

# 기본사이트 제거
if [ -f /etc/nginx/sites-enabled/default ]; then
  sudo rm -f /etc/nginx/sites-enabled/default
fi

echo "  - nginx 설정 검사"
sudo nginx -t

echo "  - nginx reload"
sudo systemctl reload nginx

echo
echo "✅ Nginx 설정 적용 완료!"
echo " - http://<서버IP>/add"
echo " - http://<서버IP>/get"
