// backend/server.js
const http = require('http');

const server = http.createServer((req, res) => {
    console.log("백엔드 서버에 요청이 도착했습니다! (5초 지연 시작...)");
    
    // 5초(5000ms) 동안 멈췄다가 응답을 보냄
    setTimeout(() => {
        res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('느린 백엔드 서버 접속까지 걸린 시간 : 5초\n');
    }, 5000);
});

server.listen(80, () => {
    console.log('느린 백엔드 서버가 80번 포트에서 대기 중입니다.');
});