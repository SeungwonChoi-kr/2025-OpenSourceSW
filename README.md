# Nginx | HTTPS (SSL/TLS Termination)
> Nginx의 SSL/TLS Termination 기능 실습
> 1. 브라우저는 로그인 페이지를 HTTPS로 요청하며 사용자가 입력한 값(ID/Password)는 TLS 구간에서 암호화되어 Nginx에 도달
> 2. Nginx는 SSL/TLS 암호화를 복호화한 뒤, 내부 백엔드 서버(Python HTTP Server, 8080 port)로 HTTP 평문 형태로 전달
> 3. 각 구간의 요청을 Wireshark로 확인

## 개발 환경
- Ubuntu

## Nginx 설치 및 실행
```bash
sudo apt update
sudo apt install nginx
sudo nginx -t
```

## Wireshark 설치 및 실행
```bash
sudo apt update
sudo apt install wireshark -y
sudo wireshark
```

## Self-Signed 인증서 생성
```bash
/* Nginx용 인증서를 생성할 디렉터리 생성 */
sudo mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

/* 인증서 생성 */
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout self.key -out self.crt
```
