자동화해서 만든 로드밸런싱 프로토타입입니다.
아래는 실행 하는 순서입니다.
# Flask + Nginx Test Server Setup



# 첫 실행시
## 1. Clone
git clone <repo_url>
cd your-repo

## 2. Activate Virtual Environment
source venv/bin/activate

## 3. Start Flask Servers
./flask_setup.sh

## 4. Apply Nginx Config
./nginx_setup.sh

## 5. Test
curl http://<server-ip>/add
curl http://<server-ip>/get

## 6. Stop Flask Servers
./flask_stop.sh

## 빈드시 종료를 시킬것

# 나중에 다시 실행시
### 반드시 첫 실행 이후 종료 스크립트를 활성화 하셔야합니다.

## 1. Start Flask Servers
./flask_setup.sh

## 2. Test
curl http://<server-ip>/add
curl http://<server-ip>/get

## 3. Stop Flask Servers
./flask_stop.sh
