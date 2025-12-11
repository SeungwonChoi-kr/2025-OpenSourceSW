# 만일 lb_proto등을 새로운 vm환경에서 설치 시연이 불가능한 경우 사용

## 단! 해당 VM에 이미 nginx, pip, venv및 venv를 통한 flask가 설치 완료 되어있어야 한다.


# 실행순서

## 1
git clone 해서 이 브랜치로 바꾸기

1. lb_proto3로 이동
2. app.py(플라스크 서버 파일)이 있는 폴더로 이동
3. venv 활성화(이건 해당 VM에서 만들고 활성화 해주어야함, 위치는 상관 없음)
4. flask_start.sh 실행해서 서버 켜기
5. 테스트하기
6. flask_stop.sh 실행해서 서버 끄기
7. VM끄기

의 순서이다.


