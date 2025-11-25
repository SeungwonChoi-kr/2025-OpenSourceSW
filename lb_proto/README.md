Nginx 로드밸런싱 테스트용 파일들

app.py와 동일한 파일, 혹은 복사하여 테스트 하고자하는 서버에 백엔드 서버로써 활용한다

해당 절차에서 준비해야 할 조건은 다음과같다

테스트 PC + OS(ubuntu24.04 사용 추천)

python 개발환경 구축

apt install을 이용해
python3.12-venv
pip를 설치한다

이후 vevn를 활용하여(선택사항)
pip insall flask를 진행하여 flask를 설치한다.

이후 app.py가 존재하는 폴더로 이동하여
python3 app.py 를 통해서 flask서버를 기동시킨다.
추가적인 설명이 필요한데 이는 아래에서 추가로 설명하겠다.


## Nginx 설치
sudo apt install 을통해서 Nginx를 설치한다.



