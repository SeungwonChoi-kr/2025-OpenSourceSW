# Nginx | HTTPS (SSL/TLS Termination)
> Nginx의 SSL/TLS Termination 기능 실습
> 1. 브라우저는 로그인 페이지를 HTTPS로 요청하며 사용자가 입력한 값(ID/Password)는 TLS 구간에서 암호화되어 Nginx에 도달
> 2. Nginx는 SSL/TLS 암호화를 복호화한 뒤, 내부 백엔드 서버(Python HTTP Server, 8080 port)로 HTTP 평문 형태로 전달
> 3. 각 구간의 요청을 Wireshark로 확인

## 개발 환경
- Ubuntu

## 1. Nginx 설치 및 실행
```bash
sudo apt update
sudo apt install nginx
sudo nginx -t
```

## 2. Wireshark 설치 및 실행
```bash
sudo apt update
sudo apt install wireshark -y
sudo wireshark
```

## 3. Self-Signed 인증서 생성
```bash
# Nginx용 인증서를 생성할 디렉터리 생성
sudo mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

# 인증서 생성 - 입력 값은 아무거나 가능 (국가/도/기관 등)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout self.key -out self.crt
```

## 4. Nginx HTTPS 설정
```bash
# Nginx 설정 파일
sudo vim /etc/nginx/sites-available/default

# 내용을 아래처럼 교체
server {
    listen 443 ssl;                              # 443번 포트에서 HTTPS 요청을 받겠다
    server_name localhost;                       # 도메인 이름

    ssl_certificate     /etc/nginx/ssl/self.crt; # 공개키 경로
    ssl_certificate_key /etc/nginx/ssl/self.key; # 개인키 경로

    location / {                            # 클라이언트가 / 경로로 요청하면 아래 처리
        proxy_pass http://127.0.0.1:8080;   # 복호화된 요청을 백엔드 서버로 전달 -> Wireshark에서 8080 포트로 GET/POST가 평문으로 보이는 이유
        proxy_set_header Host $host;        # 백엔드 서버로 Host 전달 ex) localhost
        proxy_set_header X-Real-IP $remote_addr; # 백엔드에게 클라이언트의 실제 IP를 알려줌
    }
}

server {
    listen 80;
    return 301 https://$host$request_uri;
}

# 설정 후 Nginx 재시작
sudo systemctl restart nginx
