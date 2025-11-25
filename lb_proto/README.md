Nginx 로드밸런싱 테스트용 파일들  

app.py와 동일한 파일, 혹은 복사하여 테스트 하고자하는 서버에 백엔드 서버로써 활용한다  

해당 절차에서 준비해야 할 조건은 다음과같다  

테스트 PC + OS(ubuntu24.04 사용 추천)  

## python 개발환경 구축-백엔드 서버  

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

Nginx 설정파일을 업로드된 .conf 파일로 교체한다.  
(기본적으로 Nginx는 코어수에 따라서 워커노드를 생성하지만 현재 테스트 목적에서는 필요없으므로 무시한다)  


## python 개발환경 구축, 호스트 서버  

위와 같이  
flask까지 준비한 후, 추가로 통신을 위한 pip install requests를 이행한다.  
이후 준비된  
lb_test_send_host.py 파일을 이용하여 통신하면 된다.  
해당 파일의 실행인자는  

1) url
2) request 수
3) 스레드 수(동시에 던질 스레드 수)이다.

예시)  
python3 lb_test_send_host.py http://ubuntu@<IP>/<end-point> 200 50    

해석    
해당 프로그램을 실행하여, 총 request는 200개, 스레드는 50개 활용    

응답은 다음과 같다    

      print("\n==== RESULT ====")
      print(f"Total time           : {total_time:.6f} s")                  # sec
      print(f"Avg latency          : {statistics.mean(latencies):.6f} s")  # sec
      print(f"Median latency       : {statistics.median(latencies):.6f} s")# sec
      print(f"Max latency          : {max(latencies):.6f} s")              # sec
      print(f"Min latency          : {min(latencies):.6f} s")              # sec
      print(f"Requests per second  : {num_requests / total_time:.2f} req/s")


이를 통해서 Nignx의 로드밸런싱 기능을 확인 가능하다.  
