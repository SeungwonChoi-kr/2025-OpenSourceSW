# Nginx | HTTPS (SSL/TLS Termination)
> Nginx의 SSL/TLS Termination 기능 실습
> 1. 브라우저는 로그인 페이지를 HTTPS로 요청하며 사용자가 입력한 값(ID/Password)는 TLS 구간에서 암호화되어 Nginx에 도달
> 2. Nginx는 SSL/TLS 암호화를 복호화한 뒤, 내부 백엔드 서버(Python HTTP Server, 8080 port)로 HTTP 평문 형태로 전달
> 3. 각 구간의 요청을 Wireshark로 확인

## 개발 환경
- Ubuntu

---

## 실습 방법
### 1. Nginx 설치 및 실행
```bash
sudo apt update
sudo apt install nginx
sudo nginx -t
```

### 2. Wireshark 설치
```bash
sudo apt update
sudo apt install wireshark -y
```

### 3. Self-Signed 인증서 생성
```bash
# Nginx용 인증서를 생성할 디렉터리 생성
sudo mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl

# 인증서 생성 - 입력 값은 아무거나 가능 (국가/도/기관 등)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout self.key -out self.crt
```

### 4. Nginx HTTPS 설정
```bash
# Nginx 설정 파일
sudo vim /etc/nginx/sites-available/default
```
```nginx
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
```
```bash
# 설정 후 Nginx 재시작
sudo systemctl restart nginx
```

### 5. HTTP 서버 실행
```bash
cd HTTPS_Server
python3 -m http.server 8080
```

### 6. HTTPS 서버 접속
- 브라우저에서 아래 주소 접속<br> 
`https://localhost`

### 7. Wireshark 실행 및 캡처
```bash
sudo wireshark
```
실행 후 Loopback: lo 선택

**HTTPS(443) 패킷 캡처**
- 필터 입력
```ini
tcp.port == 443
```
브라우저에서 로그인 정보 입력 후 제출하면 다음과 같이 보임:
- Client Hello
- Server Hello
- Change Cipher Spec
- TLS Application Data (암호문)<br>
👉 로그인 정보가 노출되지 않음

**HTTP(8080) 패킷 캡처**
- 필터 입력
```ini
tcp.port == 8080
```
다음처럼 평문으로 보임:
```sql
GET /?user=유저&pw=1234 HTTP/1.1
```
👉 로그인 정보가 그대로 노출됨

---

## 프로젝트 구조
- `HTTPS_Server` : HTTPS 서버용 index.html을 포함
