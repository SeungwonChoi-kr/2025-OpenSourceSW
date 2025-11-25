# Nginx | HTTPS (SSL/TLS Termination)
> Nginx의 SSL/TLS Termination 기능 실습
> 1. 브라우저는 로그인 페이지를 HTTPS로 요청하며 사용자가 입력한 값(ID/Password)는 TLS 구간에서 암호화되어 Nginx에 도달
> 2. Nginx는 SSL/TLS 암호화를 복호화한 뒤, 내부 백엔드 서버(Python HTTP Server, 8080 port)로 HTTP 평문 형태로 전달
> 3. 각 구간의 요청을 Wireshark로 확인
