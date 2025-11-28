# OpenSourceSW Team Project | 3조
## Nginx
Nginx의 대표 기능(Load Balancing, Reverse Proxy, SSL/TLS Termination) 설계 및 구현
> 각 기능은 독립된 브랜치로 구성되어 있습니다.

---

## 브랜치별 기능 구성
| 브랜치명 | 기능 | 설명 | 담당 |
| :---: | :---: | :---: | :---: |
| **`load-balancing`** | Load Balancer | 3개의 백엔드 서버를 Round Robin 방식으로 트래픽 분산 | 안상완, 최승원 |
| **`reverse-proxy-caching`** | Reverse Proxy + Caching | 캐싱 적용 전후의 응답 속도 차이 | 박준성, 이주형 |
| **`SSL/TLS-Termination`** | SSL/TLS Termination | 암호화된 HTTPS 요청을 Nginx에서 복호화 후 백엔드 HTTP로 전달 | 김가람, 정형윤 |

