// backend/server.js
const http = require('http');
const os = require('os'); // OS 정보를 가져오는 모듈

// 컨테이너의 내부 IP 주소를 찾는 함수
function getServerIP() {
    const interfaces = os.networkInterfaces();
    for (const name of Object.keys(interfaces)) {
        for (const iface of interfaces[name]) {
            // IPv4이고, 내부 주소(127.0.0.1)가 아닌 것을 찾음
            if (iface.family === 'IPv4' && !iface.internal) {
                return iface.address;
            }
        }
    }
    return 'Unknown IP';
}

const server = http.createServer((req, res) => {
    console.log(`백엔드 서버에 요청이 도착했습니다! (5초 지연 시작...)`);
    
    // 5초(5000ms) 동안 멈췄다가 응답을 보냄
    setTimeout(() => {
        res.writeHead(200, { 'Content-Type': 'text/plain; charset=utf-8' });
        res.end('느린 백엔드 서버 접속까지 걸린 시간 : 5초\n');
    }, 5000);
});

server.listen(80, () => {
    const ip = getServerIP(); // IP 가져오기
    console.log(`느린 백엔드 서버가 80번 포트에서 대기 중입니다.`);
    console.log(`백엔드 서버 내부 IP 주소: ${ip}`);
});