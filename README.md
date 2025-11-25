# Nginx Load Balancing Practice

Nginx를 사용하여 로컬 환경(Localhost)에서 로드밸런싱(Load Balancing)을 구현하는 실습 프로젝트입니다.
3개의 파이썬 웹 서버를 띄우고, Nginx가 라운드 로빈(Round Robin) 방식으로 요청을 분산 처리합니다.

## 📂 파일 구조 및 설명 (File Structure)

이 저장소의 파일들은 실제 리눅스 시스템의 설정 파일과 다음과 같이 매핑됩니다.

| 파일명 | 설명 | 실제 시스템 위치 |
| :--- | :--- | :--- |
| **`nginx.conf`** | Nginx의 전역 설정 파일입니다. <br> 테스트 시 순차적인 로드밸런싱 확인을 위해 `worker_processes`를 1로 설정했습니다. | `/etc/nginx/nginx.conf` |
| **`load_balancer.conf`** | 실제 로드밸런싱 로직(Upstream)이 담긴 설정 파일입니다. <br> 8001~8003 포트로 요청을 분산하며, 브라우저 캐시 방지 설정이 포함되어 있습니다. | `/etc/nginx/sites-available/default` |
| **`server1/` ~ `3/`** | 테스트용 백엔드 서버 디렉토리입니다. <br> 각각 식별 가능한 `index.html`을 포함하고 있습니다. | 사용자 홈 디렉토리 등 임의 위치 |

---

## 🚀 실습 방법 (How to Run)

### 1. 환경 준비 (Prerequisites)
* Ubuntu/Debian Linux 환경
* Nginx 설치 (`sudo apt install nginx`)
* Python 3 설치 (Linux 기본 내장)

### 2. 백엔드 서버 실행
터미널 3개를 열고, 각각 아래 명령어를 실행하여 8001, 8002, 8003 포트 서버를 띄웁니다.

```bash
# Terminal 1
cd server1
python3 -m http.server 8001

# Terminal 2
cd server2
python3 -m http.server 8002

# Terminal 3
cd server3
python3 -m http.server 8003
```

### 3. Nginx 설정 적용
저장소에 있는 설정 파일들을 실제 시스템 경로로 복사하여 적용합니다.

```bash
# 1. 메인 설정 적용 (worker process 설정 등)
sudo cp nginx.conf /etc/nginx/nginx.conf

# 2. 로드밸런싱 설정 적용
sudo cp load_balancer.conf /etc/nginx/sites-available/default

# 3. 설정 테스트 및 재시작
sudo nginx -t
sudo systemctl restart nginx
```

### 4. 테스트 (Testing)
터미널에서 `curl` 명령어를 사용하거나 웹 브라우저로 접속하여 서버가 순환하는지 확인합니다.

```bash
curl http://localhost
```

**예상 결과:**
요청을 보낼 때마다 Server 1, 2, 3이 번갈아가며 응답합니다.

```text
<h1>Hello from Server 1</h1>
...
<h1>Hello from Server 2</h1>
...
<h1>Hello from Server 3</h1>
```
