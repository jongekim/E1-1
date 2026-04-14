# 개발 워크스테이션 미션 결과

## 1) 프로젝트 개요
터미널 CLI, Docker(OrbStack), Git/GitHub를 사용해 재현 가능한 개발 환경을 구성하고 검증했다.
핵심은 명령 실행 결과(로그/접속/데이터 유지)로 동작을 증명하는 것이다.

## 2) 실행 환경
- OS: macOS
- Shell: zsh
- Docker Engine: OrbStack
- Docker Context: orbstack
- Docker Version: 28.5.2
- Git Version: 2.53.0

증거:
- 명령/출력 통합 로그: `mission/evidence/terminal.log`

## 3) 수행 항목 체크리스트
- [x] 터미널 기본 조작 (pwd, ls -la, cd, mkdir, cp, mv, rm, cat, touch)
- [x] 권한 실습 (파일/디렉토리 각각 변경 전/후 기록)
- [x] Docker 설치/점검 (`docker --version`, `docker info`, `docker context ls`)
- [x] Docker 운영 명령 (`docker images`, `docker ps -a`, `docker logs`, `docker stats`)
- [x] `hello-world` 실행 성공
- [x] `ubuntu` 컨테이너 실행 후 내부 명령(`ls`, `echo`) 수행
- [x] Dockerfile 기반 커스텀 이미지 빌드/실행
- [x] 포트 매핑 접속 검증 (`8080`, `8081`)
- [x] 바인드 마운트 반영 검증
- [x] 볼륨 영속성 검증
- [x] Git 설정 점검 (`git config --list`)
- [x] GitHub 연동 증거 확보 (CLI `git push` 성공 로그)
- [x] 포트 매핑 접속 증거 확보 (`curl` 응답 로그)
- [ ] VSCode GitHub 로그인/연동 스크린샷 첨부 (수동)
- [ ] 브라우저 주소창 포함 접속 스크린샷 첨부 (수동)

## 4) 디렉토리 구조
```text
.
├── To_Do.txt
├── README.md
└── mission
    ├── Dockerfile
    ├── app/
    │   └── index.html
    ├── bind_site/
    │   └── index.html
    ├── evidence/
    │   └── terminal.log
    ├── perm_lab/
    ├── practice/
    └── screenshots/
```

## 5) 검증 방법 + 결과 위치

### A. 터미널 조작
- 확인 명령: `pwd`, `ls -la`, `mkdir`, `cp`, `mv`, `rm`, `cat`, `touch`
- 결과 위치: `mission/evidence/terminal.log`

### B. 권한 변경
- 확인 명령: `ls -l`, `chmod 755/700`, `chmod 644/600`
- 결과 위치: `mission/evidence/terminal.log`

### C. Docker 점검
- 확인 명령: `docker --version`, `docker info`, `docker context ls`
- 결과 위치: `mission/evidence/terminal.log`

### D. Docker 운영
- 확인 명령: `docker images`, `docker ps -a`, `docker logs mission-web-8080`, `docker stats --no-stream mission-web-8080`
- 결과 위치: `mission/evidence/terminal.log`

### E. Dockerfile 커스텀 이미지
- 베이스 이미지: `nginx:alpine`
- 커스텀 포인트:
  - `LABEL` 추가: 이미지 식별 메타데이터
  - `ENV APP_ENV=dev` 추가: 런타임 환경값 예시
  - `COPY app/ ...`로 정적 페이지 교체
- 확인 명령: `docker build -t mission-web:1.0 .`
- 결과 위치: `mission/evidence/terminal.log`

### F. 포트 매핑 검증
- 실행: `docker run -d --name mission-web-8080 -p 8080:80 mission-web:1.0`
- 실행: `docker run -d --name mission-web-8081 -p 8081:80 mission-web:1.0`
- 확인: `curl -i http://localhost:8080`, `curl -i http://localhost:8081`
- 결과 위치: `mission/evidence/terminal.log`
- 비고: 본 결과물은 `curl` 응답 로그를 증거로 기록했으며, 브라우저 주소창 캡처는 수동 추가가 필요

### G. 바인드 마운트 검증
- 실행: `docker run -d --name bind-web -p 8090:80 -v <host>/bind_site:/usr/share/nginx/html nginx:alpine`
- 확인: 호스트 `bind_site/index.html` 수정 전/후 `curl http://localhost:8090` 응답 변화
- 결과 위치: `mission/evidence/terminal.log`

### H. 볼륨 영속성 검증
- 생성: `docker volume create mission_data`
- 1차 컨테이너: 파일 생성 `/data/keep.txt`
- 컨테이너 삭제 후 2차 컨테이너 재연결
- 확인: `cat /data/keep.txt`에서 동일 데이터 유지
- 결과 위치: `mission/evidence/terminal.log`

### I. Git/GitHub
- 확인 명령: `git config --list`
- 결과 위치: `mission/evidence/terminal.log`
- 연동 증거: `git push` 성공 출력(원격 반영) 및 `git status`/`git log` 결과를 로그에 기록

## 11) 명령/출력 발췌 (코드블록)
아래는 평가 항목 대응을 위해 `mission/evidence/terminal.log`에서 발췌한 핵심 명령/출력이다.

```bash
$ pwd
/Users/okbaronok23110/Desktop/E1-1/mission

$ ls -la
drwxr-xr-x ... mission
...
```

```bash
$ chmod 700 perm_lab/dir1
$ chmod 600 perm_lab/file1.txt
$ ls -ld perm_lab/dir1 && ls -l perm_lab/file1.txt
drwx------ ... perm_lab/dir1
-rw------- ... perm_lab/file1.txt
```

```bash
$ docker --version
Docker version 28.5.2, build ecc6942

$ docker info
Context:    orbstack
Operating System: OrbStack
...
```

```bash
$ docker run --name hw-test hello-world
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

```bash
$ docker run -dit --name ubuntu-lab ubuntu bash
$ docker exec ubuntu-lab ls /
bin
boot
...
$ docker exec ubuntu-lab bash -lc 'echo hello-from-ubuntu-container'
hello-from-ubuntu-container
```

```bash
$ docker build -t mission-web:1.0 .
#7 naming to docker.io/library/mission-web:1.0 done
```

```bash
$ curl -i http://localhost:8080 | head -n 20
HTTP/1.1 200 OK
Server: nginx/1.29.8

$ curl -i http://localhost:8081 | head -n 20
HTTP/1.1 200 OK
Server: nginx/1.29.8
```

```bash
$ curl -s http://localhost:8090
Bind Mount Version 1

$ curl -s http://localhost:8090
Bind Mount Version 2 (Host Changed)
```

```bash
$ docker volume create mission_data
mission_data

$ docker exec vol-test-2 bash -lc 'cat /data/keep.txt'
persistent-data
```

```bash
$ git config --list | grep -E "user.name|user.email|init.defaultbranch"
init.defaultbranch=main
user.name=okbaronok23110
user.email=okbaronok23110@users.noreply.github.com

$ cd /Users/okbaronok23110/Desktop/E1-1 && git push
Everything up-to-date
```

## 6) 핵심 기술 원리

### 절대 경로 vs 상대 경로
- 절대 경로: 루트(`/`)부터 전체 경로를 명시해 현재 위치와 무관하게 동일하게 동작.
- 상대 경로: 현재 작업 디렉토리 기준으로 짧고 이동이 잦은 실습에 편리.

### 권한 r/w/x와 숫자 표기
- 권한 값: `r=4`, `w=2`, `x=1`
- 755 = 소유자 `rwx(7)`, 그룹 `r-x(5)`, 기타 `r-x(5)`
- 644 = 소유자 `rw-(6)`, 그룹 `r--(4)`, 기타 `r--(4)`

### 이미지와 컨테이너 차이 (빌드/실행/변경)
- 이미지: 빌드 결과물(템플릿), 불변에 가깝다.
- 컨테이너: 이미지의 실행 인스턴스, 실행 중 상태 변경이 생긴다.
- 같은 이미지를 여러 컨테이너로 반복 실행해도 환경을 재현할 수 있다.

### 포트 매핑 필요 이유
- 컨테이너 내부 포트는 호스트에서 직접 접근되지 않는다.
- `-p <host>:<container>` 매핑으로 호스트 네트워크에 서비스 접근점을 만든다.

### Docker 볼륨(영속 데이터)
- 컨테이너 파일시스템과 별도 저장소를 사용해 데이터 수명을 분리한다.
- 컨테이너 삭제 후에도 볼륨 데이터가 유지된다.

### Git vs GitHub
- Git: 로컬 버전 관리 도구(커밋/브랜치/이력 관리)
- GitHub: 원격 저장소/협업 플랫폼(PR, 이슈, 코드 공유)

## 7) 컨테이너 동작 관찰: attach vs exec
- `attach`: 컨테이너의 메인 프로세스 표준 입출력에 직접 붙는다.
- `exec`: 실행 중 컨테이너 내부에 새 프로세스를 추가 실행한다.
- 본 실습에서는 `docker exec ubuntu-lab ...`로 내부 명령을 안전하게 실행했다.

## 8) 트러블슈팅 (2건 이상)

### 사례 1: 컨테이너 이름 충돌
- 문제: `docker run` 시 `Conflict. The container name ... is already in use` 발생
- 가설: 이전 실행에서 동일 이름 컨테이너가 이미 존재
- 확인: `docker ps -a`로 동일 이름 컨테이너 존재 확인
- 해결: 기존 컨테이너 제거(`docker rm -f <name>`) 후 재실행 또는 다른 이름 사용

### 사례 2: 볼륨 미사용 시 데이터 유실 위험
- 문제: 컨테이너 삭제 후 내부 파일이 사라질 수 있음
- 가설: 데이터가 컨테이너 레이어에만 저장됨
- 확인: 볼륨 연결 후 재시작 실험에서 데이터 유지됨(`persistent-data`)
- 해결: 영속 데이터는 반드시 볼륨(`-v mission_data:/data`) 사용

### 사례 3: 공유 셸 heredoc 대기 상태
- 문제: 긴 명령 실행 후 셸이 `heredoc>` 상태에 머물러 후속 명령 실패
- 가설: 미완성 heredoc 입력이 종료되지 않음
- 확인: 일반 명령이 즉시 실행되지 않고 heredoc 프롬프트 반복
- 해결: 명령을 짧게 분리 실행하고, 복잡한 입력은 파일 단위로 나눠 처리

## 9) 재현 가이드
아래 순서대로 실행하면 동일 결과를 재현할 수 있다.
1. OrbStack 실행
2. `mission/` 진입 후 `mission/evidence/terminal.log`의 명령 순서 실행
3. `docker build` → `docker run -p` → `curl` 확인
4. 바인드 마운트 파일 수정 전/후 응답 비교
5. 볼륨 생성/재연결로 데이터 유지 확인

## 10) 보안/개인정보 보호
- 문서와 로그에 토큰/비밀번호/개인키/인증코드를 포함하지 않는다.
- 노출 의심 시 즉시 문서/히스토리에서 제거하고 자격 증명을 재발급한다.

## 12) 자동 점검
아래 명령으로 제출 필수 파일과 증거 로그를 자동 점검할 수 있다.

bash mission/check_submission.sh

점검 결과가 ACTION NEEDED이면 누락 항목을 채운 뒤 다시 실행한다.
