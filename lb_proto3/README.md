# 만일 lb_proto등을 새로운 vm환경에서 설치 시연이 불가능한 경우 사용

## 단! 해당 VM에 이미 nginx, pip, venv및 venv를 통한 flask가 설치 완료 되어있어야 한다.


# 사전준비

## 만일 자기가 nignx 설정이 안되어있다?  
설정하는법  
일단 설정 파일이 있는 폴더로 이동.  

다음과 같은 명령어로 디폴트 설정 삭제

    sudo rm /etc/nginx/sites-enabled/default

만약 불안하다면 다음과 같이 미리 복사하기(현재 코드는 홈디렉토리에 복사함)

    sudo cp /etc/nginx/sites-enabled/default ~/

이후에 다음과 같이 붙여넣기  

    sudo cp flask-lb.conf /etc/nginx/sites-available/flask-lb.conf

사용 가능하게 연결해주기  

    sudo ln -s /etc/nginx/sites-available/flask-lb.conf /etc/nginx/sites-enabled/flask-lb.conf

이후에 설정검사하고 다시 켜기  

    sudo nginx -t
    sudo systemctl reload nginx  // 이거 아니면
    sudo systemctl restart nginx  //이거 

-----


## 자기가 flask 등이 설치가 안되어있다?

    sudo apt update
    sudo apt install python3-pip
    sdoo apt install pyhton3.12-venv // 이건 자기 버전에 맞게 설치하던, 아니면 그냥 python3-venv로 할 것

으로 설치 해주고 가상환경 만들고 싶은 폴더 만들거나 가서  

    python3 -m venv <생성할 가상환경 폴더 이름>

으로 생성해주고

    source <생성한 가상환경 폴더 경로>/bin/activate 

로 가상환경 실행시키고,  
켜지면 쉘 프롬프트의  현재 입력창 맨 왼쪽에    
**(생성한 가상환경 폴더 이름) 유저명@호스트명:<작업중 경로>$**  
으로 보일것이다. 안뜨면 이상한거니 따로 검색해서 해결 할 것.   
이후 가상환경이 켜졌다면.     

    pip3 list

해보면 아무것도 없을테니

    pip3 install flask

로 flask 설치하자   

추가로 가상환경 끄고싶으면  현재 쉘 프롬프트에   

    deactivate

라고 입력하면 된다.(그럼 맨 왼쪽 () <-- 사라질것이다. )


------


# 테스트 순서(백엔드에서 서버 키고 끄는 방법)
git clone 해서 이 브랜치로 바꾸기

1. lb_proto3로 이동
3. app.py(플라스크 서버 파일)이 있는 폴더로 이동
4. venv 활성화(이건 해당 VM에서 만들고 활성화 해주어야함, 위치는 상관 없음)
5. flask_start.sh 실행해서 서버 켜기
6. 테스트하기
7. flask_stop.sh 실행해서 서버 끄기
8. VM끄기

의 순서이다.
### 무조건 stop 해줘야한다. 안그러면 ps aux | grep app.py 해서 일일이 kill 해주어야 하니 명심할 것.


# 호스트에서 테스트 하는 방법  

프로젝트 디렉토리에 "lb_test_host.py" 라고 있을것이다. 그것을 복사하던 어떻게 해서 테스트를 진행할 host pc에 준비할 것.  

### 이때 호스트 PC에는 python 패키지인 "requests"가 설치되어있어야 한다.(venv 깔고 거기다 올리는 것 추천).  

## 테스트 방법  

말한대로 준비 되었다면 해당 소스코드가 존재하는 HOST PC의 폴더로 이동한다 .  

그리고 다음과 같이 실행한다.  

    python3 <해당소스코드명> <URL> <총 요청 수> <병렬성제어>

이렇게 총 3가지 옵션이 존재하는데, 옵션은 다음과 같다  

### <URL> , 통신하고자 하는 서버의 엔트포인트

### <총 요청 수>, 날릴 request의 숫자, 디폴트는 100

### <병렬성 제어>, 디폴트는 40, 코드안에 with ThreadPoolExecutor(max_workers=concurrency) as executor: 라고있는데, 그냥 한꺼번에 날릴횟수다. 만약 200으로 설정하고 총 요청이 2000이면, 200씩 10번 날린다고 생각하면 된다.

그러면  

    print(f"Total time           : {total_time:.6f} s")
    print(f"Avg latency          : {statistics.mean(latencies):.6f} s")
    print(f"Median latency       : {statistics.median(latencies):.6f} s")
    print(f"Max latency          : {max(latencies):.6f} s")
    print(f"Min latency          : {min(latencies):.6f} s")
    print(f"Requests per second  : {num_requests / total_time:.2f} req/s")

이런식으로 출력코드가 존재하니 확인하면 된다.


