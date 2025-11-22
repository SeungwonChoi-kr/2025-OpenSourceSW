# 🚀 NGINX Reverse Proxy Caching

이 브랜치는 **NGINX의 리버스 프록시(Reverse Proxy)와 캐싱(Caching) 기능**을 실습하고 시연하기 위해 구성되었습니다.

의도적으로 응답 속도를 늦춘 백엔드 서버(Node.js)를 NGINX 뒤에 배치하여, **캐싱 적용 전후의 응답 속도 차이**를 시각적으로 검증할 수 있습니다.

## 📋 설치 요구 사항 (Requirements)

이 프로젝트를 실행하기 위해서는 사용자의 컴퓨터에 다음 도구가 설치되어 있어야 합니다.

  * **[Git](https://git-scm.com/)** : 코드 다운로드용
  * **[Docker Desktop](https://www.docker.com/products/docker-desktop/)** : 서버 실행용 (실행 상태여야 함)

***

## 🛠️ 설치 및 실행 가이드 (Installation & Usage)

### 1\. 프로젝트 다운로드 (Clone)

터미널을 열고 아래 명령어를 입력하여 프로젝트를 다운받습니다.

```bash
# 코드 다운로드
git clone https://github.com/SeungwonChoi-kr/2025-OpenSourceSW.git

# 프로젝트 폴더로 이동
cd 2025-OpenSourceSW
```

### 2\. 작업 브랜치로 이동

리버스 프록시 캐싱을 구현한 `reverse-proxy-caching` 브랜치로 전환합니다.

```bash
# 브랜치 변경
git checkout reverse-proxy-caching
```

### 3\. 서버 실행 (Docker)

Docker를 이용해 NGINX와 백엔드 서버를 실행합니다.

```bash
# 서버 시작 (백그라운드 모드)
docker-compose up -d
```

> **참고** : 처음 실행 시 이미지를 다운로드하느라 1\~2분 정도 소요될 수 있습니다.

***

## 🖥️ 시연 및 테스트 방법 (Demo Scenario)

서버가 정상적으로 실행되었다면, 웹 브라우저를 통해 캐싱 효과를 직접 확인할 수 있습니다.

### 1단계 : 접속 및 지연 확인 (Cache MISS)

1.  웹 브라우저(Chrome 권장)를 엽니다.
2.  **`F12`** 키를 눌러 **개발자 도구**를 열고 **[Network]** 탭을 클릭합니다.
3.  주소창에 **`http://localhost`** 를 입력하고 접속합니다.
4.  **결과** : 화면이 즉시 뜨지 않고, 약 **5초 간의 지연(Loading)** 후 페이지가 나타납니다.
      * *이유 : NGINX에 저장된 캐시가 없어, 느린 백엔드 서버에서 데이터를 직접 가져왔기 때문입니다.*

### 2단계 : 캐싱 효과 확인 (Cache HIT)

1.  브라우저의 **새로고침(F5)** 버튼을 누릅니다.
2.  **결과** : 지연 없이 **즉시(0.01초 이내)** 페이지가 로딩됩니다.
      * *이유 : NGINX가 첫 번째 요청 때 저장해 둔 데이터를 백엔드를 거치지 않고 바로 반환(캐싱)했기 때문입니다.*

### 3단계 : 헤더 정보 검증

개발자 도구(Network 탭)에서 `localhost` 요청을 클릭하고 **Headers** 탭을 확인합니다.

  * **`X-Client-IP`** : NGINX가 사용자의 실제 IP를 백엔드에 전달했음을 보여줍니다. (리버스 프록시)
  * **`X-Actual-Backend-IP`** : NGINX가 전달한 백엔드의 IP를 보여줍니다. (캐시 적중 시 사라짐)
  * **`X-Cache-Status: HIT`** : 캐시가 적중했음을 의미합니다. (첫 접속 시엔 `MISS`)
  * **`X-Nginx-Message`** : NGINX가 요청을 확인하고 처리했음을 증명하는 메시지가 출력됩니다.

Docker의 **Containers** 탭에서 `2025-opensourcesw` 컨테이너를 확인합니다.

  * **`backend`** : 백엔드 서버 내부 IP 주소가 위의 헤더 중 `X-Actual-Backend-IP`와 동일한 것을 확인합니다.
    
> **참고** : 캐시가 적중(HIT)한 경우에는 NGINX가 백엔드 서버와 통신하지 않으므로 `X-Actual-Backend-IP` 헤더가 나타나지 않을 수 있습니다.

***

## 🛑 서버 종료 및 정리

시연이 끝나면 다음 명령어로 서버를 종료하고 정리합니다.

```bash
# 서버 종료 및 정리
docker-compose down
```

***

## 📂 프로젝트 구조

  * **`docker-compose.yml`** : NGINX와 백엔드(Node.js) 컨테이너를 구성하고 연결하는 설계도
  * **`nginx.conf`** : 리버스 프록시 및 캐싱 정책(유효 시간, 저장 경로 등) 설정 파일
  * **`backend/server.js`** : 5초의 응답 지연을 의도적으로 발생시키는 테스트용 백엔드 서버 코드

-----

**2025-2 오픈소스SW개발 기말과제 박준성, 이주형**
