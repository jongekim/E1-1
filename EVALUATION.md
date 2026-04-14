# 개발 워크스테이션 미션 평가 가이드

## 1) 기능 동작 검증

### ✓ 터미널에서 기본 명령어로 폴더/파일 생성•이동•삭제를 수행한 흔적이 있는가?

**검증 방법:**
```bash
# 로그에서 다음 명령어들 확인
grep -E "mkdir|cp|mv|rm|touch" mission/evidence/terminal.log

# 수행된 작업 확인
grep -A3 "mkdir -p practice" mission/evidence/terminal.log
grep -A3 "cp practice/a/hello.txt" mission/evidence/terminal.log
grep -A3 "mv practice/b" mission/evidence/terminal.log
grep -A3 "rm practice/b" mission/evidence/terminal.log
```

**기대 결과:**
- [x] `mkdir` 으로 디렉토리 생성(`practice/a`, `practice/b`)
- [x] `touch` 로 파일 생성(`empty.txt`)
- [x] `cp` 로 파일 복사
- [x] `mv` 로 파일 이동/이름변경
- [x] `rm` 으로 파일 삭제
- [x] 모든 명령의 출력 또는 결과가 [mission/evidence/terminal.log](mission/evidence/terminal.log) 에 기록됨

---

### ✓ 파일 권한 변경 결과가 확인되는가?

**검증 방법:**
```bash
# 권한 변경 전 상태 확인
grep "ls -ld perm_lab/dir1 && ls -l perm_lab/file1.txt" mission/evidence/terminal.log | head -n 2

# 755/644 로 설정
grep "chmod 755 perm_lab/dir1" mission/evidence/terminal.log
grep "chmod 644 perm_lab/file1.txt" mission/evidence/terminal.log

# 700/600 으로 변경
grep "chmod 700 perm_lab/dir1" mission/evidence/terminal.log
grep "chmod 600 perm_lab/file1.txt" mission/evidence/terminal.log

# 변경 후 확인
grep "drwx------" mission/evidence/terminal.log
grep "\-rw-------" mission/evidence/terminal.log
```

**기대 결과:**
- [x] 권한 변경 전: `drwxr-xr-x`, `-rw-r--r--` (기본값)
- [x] 755 설정 후: `drwxr-xr-x`, `-rw-r--r--`
- [x] 700/600 설정 후: `drwx------`, `-rw-------` 확인
- [x] 변경 전/후 비교가 [README.md](README.md#L116-L122) 에 표시됨

---

### ✓ docker --version 이 출력되고, Docker가 동작 가능한 상태인가?

**검증 방법:**
```bash
# 버전 확인
grep "docker --version" mission/evidence/terminal.log
grep "Docker version" mission/evidence/terminal.log

# Docker 데몬 상태 확인
grep "docker info" mission/evidence/terminal.log
grep "Context:.*orbstack\|Operating System: OrbStack" mission/evidence/terminal.log
```

**기대 결과:**
- [x] `Docker version 28.5.2, build ecc6942` 출력 확인
- [x] `docker info` 에서 `Context: orbstack` 표시
- [x] `Operating System: OrbStack` 확인
- [x] [README.md](README.md#L7-L16) 에 버전·환경 정보 기록

---

### ✓ docker run hello-world 가 정상 실행되는가?

**검증 방법:**
```bash
# hello-world 실행 로그
grep -A20 "docker run --name hw-test hello-world" mission/evidence/terminal.log

# 성공 메시지 확인
grep "Hello from Docker!" mission/evidence/terminal.log
```

**기대 결과:**
- [x] 명령: `docker run --name hw-test hello-world`
- [x] 출력: `Hello from Docker!` 및 정상 실행 메시지
- [x] [mission/evidence/terminal.log](mission/evidence/terminal.log) 에 전체 로그 기록
- [x] [README.md](README.md#L135-L138) 에 발췌 기록

---

### ✓ 이미지/컨테이너 목록 확인 및 정리 흔적이 있는가?

**검증 방법:**
```bash
# 이미지 목록
grep "docker images" mission/evidence/terminal.log

# 컨테이너 목록
grep "docker ps -a" mission/evidence/terminal.log

# 정리 흔적 (stop, rm)
grep "docker stop\|docker rm -f" mission/evidence/terminal.log
```

**기대 결과:**
- [x] `docker images` 로 이미지 목록(`nginx:alpine`, `ubuntu`, `hello-world`, 커스텀 이미지 등)
- [x] `docker ps` 로 실행 중인 컨테이너 확인
- [x] `docker ps -a` 로 전체 컨테이너 상태 확인(종료된 것 포함)
- [x] 불필요한 컨테이너 정리(`docker rm -f`)
- [x] [mission/evidence/terminal.log](mission/evidence/terminal.log) 에 모든 명령/출력 기록

---

### ✓ Dockerfile로 이미지 빌드가 가능한가?

**검증 방법:**
```bash
# Dockerfile 내용 확인
cat mission/Dockerfile

# 빌드 명령 확인
grep "docker build -t mission-web:1.0" mission/evidence/terminal.log

# 빌드 성공 메시지
grep "naming to docker.io/library/mission-web:1.0" mission/evidence/terminal.log

# 빌드된 이미지 확인
grep "mission-web.*1.0" mission/evidence/terminal.log | grep "IMAGE ID"
```

**기대 결과:**
- [x] [mission/Dockerfile](mission/Dockerfile) 존재 및 유효성
- [x] 베이스 이미지: `nginx:alpine`
- [x] 커스텀 요소: `LABEL`, `ENV APP_ENV=dev`, `COPY app/`
- [x] 빌드 명령: `docker build -t mission-web:1.0 .`
- [x] 빌드 성공 로그: [mission/evidence/terminal.log](mission/evidence/terminal.log)
- [x] 이미지 생성 확인

---

### ✓ 매핑된 포트로 접속이 가능한가?

**검증 방법:**
```bash
# 포트 8080 매핑 실행
grep "docker run -d --name mission-web-8080 -p 8080:80" mission/evidence/terminal.log

# 포트 8081 매핑 실행
grep "docker run -d --name mission-web-8081 -p 8081:80" mission/evidence/terminal.log

# curl 접속 성공 확인
grep "curl -i http://localhost:8080" mission/evidence/terminal.log -A5
grep "curl -i http://localhost:8081" mission/evidence/terminal.log -A5

# HTTP 200 응답 확인
grep "HTTP/1.1 200 OK" mission/evidence/terminal.log
```

**기대 결과:**
- [x] 컨테이너 2개 실행(`-p 8080:80`, `-p 8081:80`)
- [x] `curl http://localhost:8080` → `HTTP/1.1 200 OK`
- [x] `curl http://localhost:8081` → `HTTP/1.1 200 OK`
- [x] 브라우저 스크린샷: [mission/screenshots/web-8080.png](mission/screenshots/web-8080.png), [mission/screenshots/web-8081.png](mission/screenshots/web-8081.png)
- [x] [README.md](README.md#L155-L163) 에 curl 응답 발췌

---

### ✓ Docker 볼륨 데이터가 컨테이너 삭제 후에도 유지되는가?

**검증 방법:**
```bash
# 볼륨 생성
grep "docker volume create mission_data" mission/evidence/terminal.log

# 1차 컨테이너에서 파일 작성
grep "docker run -d --name vol-test-1 -v mission_data:/data" mission/evidence/terminal.log
grep "echo persistent-data > /data/keep.txt" mission/evidence/terminal.log

# 1차 컨테이너 삭제
grep "docker rm -f vol-test-1" mission/evidence/terminal.log

# 2차 컨테이너 실행
grep "docker run -d --name vol-test-2 -v mission_data:/data" mission/evidence/terminal.log

# 데이터 확인 (영속성 증명)
grep "persistent-data" mission/evidence/terminal.log | tail -n 1
```

**기대 결과:**
- [x] 볼륨 생성: `mission_data`
- [x] 1차 컨테이너에서 `/data/keep.txt` 작성
- [x] 1차 컨테이너 삭제 후 2차 컨테이너 생성
- [x] 2차 컨테이너에서 `cat /data/keep.txt` → `persistent-data` 확인
- [x] 데이터 영속성 증명
- [x] [mission/evidence/terminal.log](mission/evidence/terminal.log) 에 전체 과정 기록

---

### ✓ Git 설정 및 GitHub 연동이 확인되는가?

**검증 방법:**
```bash
# Git 사용자 정보 확인
grep "git config --list | grep" mission/evidence/terminal.log
grep "user.name=okbaronok23110" mission/evidence/terminal.log
grep "user.email=okbaronok23110@users.noreply.github.com" mission/evidence/terminal.log

# Git 기본 브랜치 확인
grep "init.defaultbranch=main" mission/evidence/terminal.log

# GitHub 푸시 성공
grep "git push" mission/evidence/terminal.log
grep "Everything up-to-date\|To https://github.com" mission/evidence/terminal.log
```

**기대 결과:**
- [x] `git config --global user.name` 설정
- [x] `git config --global user.email` 설정
- [x] `git config --global init.defaultBranch main` 설정
- [x] `git push` 성공 출력
- [x] GitHub 원격 저장소 링크 활성화
- [x] [README.md](README.md#L182-L189) 에 설정/연동 내용 기록

---

## 2) 동작 구조 설계

### ✓ 프로젝트 디렉토리 구조를 어떤 기준으로 구성했는지 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L35-L51)

**기대 설명:**
```
mission/
├── Dockerfile        # 컨테이너 이미지 정의
├── app/              # 웹 서버 정적 콘텐츠
├── bind_site/        # 바인드 마운트 테스트용 콘텐츠
├── perm_lab/         # 권한 변경 실습 디렉토리
├── practice/         # 터미널 조작 실습 디렉토리
├── evidence/         # 모든 명령/출력 로그
├── screenshots/      # 접속 증거 스크린샷
└── check_submission.sh # 자동 점검 스크립트
```

**핵심 기준:**
- [x] 기능별 폴더 분리 (app, bind_site, perm_lab, practice)
- [x] 증거물 중앙화 (evidence, screenshots)
- [x] 재현성 보장 (스크립트 자동화)

---

### ✓ 포트/볼륨 설정을 어떤 방식으로 재현 가능하게 정리했는지 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L80-L102)

**포트 설정 재현:**
```bash
# 포트 8080 재현 명령
docker run -d --name mission-web-8080 -p 8080:80 mission-web:1.0

# 포트 8081 재현 명령
docker run -d --name mission-web-8081 -p 8081:80 mission-web:1.0

# 검증
curl http://localhost:8080
curl http://localhost:8081
```

**볼륨 설정 재현:**
```bash
# 볼륨 생성
docker volume create mission_data

# 컨테이너 연결
docker run -d --name vol-test -v mission_data:/data ubuntu sleep infinity

# 데이터 작성/검증
docker exec vol-test bash -lc "echo data > /data/file.txt"
docker exec vol-test bash -lc "cat /data/file.txt"

# 컨테이너 삭제 후에도 데이터 유지 검증
docker rm -f vol-test
docker run -d --name vol-test-2 -v mission_data:/data ubuntu
docker exec vol-test-2 bash -lc "cat /data/file.txt"
```

**기대 결과:**
- [x] README 문서에 명령 + 설명 포함
- [x] [mission/evidence/terminal.log](mission/evidence/terminal.log) 에 실제 실행 기록
- [x] 평가자가 명령을 복사해서 즉시 재현 가능

---

## 3) 핵심 기술 원리 적용

### ✓ 이미지와 컨테이너의 차이를 "빌드/실행/변경" 관점에서 구분해 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L202-L205)

**설명 기준:**

| 관점 | 이미지 | 컨테이너 |
|------|--------|---------|
| **빌드** | `docker build` 로 Dockerfile 기반 생성 | 이미지 기반으로 `docker run` 실행 |
| **실행** | 파일/패키지만 포함 (템플릿) | 실행 중인 프로세스 인스턴스 |
| **변경** | 불변(수정 시 새로 빌드) | 실행 중 상태 변경 가능 (임시) |
| **영속성** | 저장소에 유지 | 컨테이너 삭제 시 상태 사라짐 |
| **재현성** | 같은 이미지 = 같은 환경 | 컨테이너마다 독립적 실행 |

**검증 명령:**
```bash
# 같은 이미지로 여러 컨테이너 실행
docker build -t test-img .
docker run -d --name container1 test-img
docker run -d --name container2 test-img
docker run -d --name container3 test-img

# 각 컨테이너는 독립적
docker ps -a
# 3개 모두 같은 이미지에서 생성되었지만 별도 인스턴스
```

---

### ✓ 컨테이너 내부 포트로 직접 접속할 수 없는 이유와 필요한 이유를 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L207-L209)

**설명:**

**직접 접속 불가 이유:**
- 컨테이너는 격리된 네트워크 네임스페이스 사용
- 호스트와 분리된 네트워크 스택 → 내부 포트 직접 노출 안 됨
- 예: `localhost:80` 접속 시 컨테이너 내부 80포트에 자동 매핑 안 됨

**필요한 이유:**
- 호스트 → 컨테이너 통신 필요 (웹앱 접속 등)
- 포트 매핑(`-p 8080:80`)으로 호스트 포트를 컨테이너 포트에 연결
- 모든 컨테이너를 고유 포트로 독립 실행 가능

**검증 명령:**
```bash
# 포트 매핑 없이 실행
docker run -d --name nginx-no-port nginx

# 호스트에서 직접 접근 시도 (실패)
curl http://localhost:80  # 연결 안 됨

# 포트 매핑 추가 후 실행
docker run -d --name nginx-with-port -p 8080:80 nginx

# 호스트에서 접근 (성공)
curl http://localhost:8080  # 성공
```

---

### ✓ 절대 경로/상대 경로를 어떤 상황에서 선택하는지 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L193-L195)

**설명:**

| 상황 | 경로 유형 | 예시 | 사용 이유 |
|------|----------|------|----------|
| **정확하고 명확해야 함** | 절대 경로 | `/Users/okbaronok23110/Desktop/E1-1/mission/bind_site:/usr/share/nginx/html` | 재현 가능성, Dockerfile COPY/ADD |
| **현재 디렉토리 기준** | 상대 경로 | `./app`, `../practice` | 이동 많을 때, 스크립트 작성 |
| **재현 가능성 필요** | 절대 경로 또는 변수 | 환경변수 조합 | CI/CD 파이프라인 |

**검증 명령:**
```bash
# 절대 경로 확인
pwd  # /Users/okbaronok23110/Desktop/E1-1/mission
ls -la /Users/okbaronok23110/Desktop/E1-1/mission/app/

# 상대 경로 확인
cd mission
ls -la ./app/
ls -la ../mission/app/  # 한 단계 위로 올라가서 다시 내려옴

# Dockerfile에서 절대 경로 사용
cat mission/Dockerfile | grep COPY
# COPY app/ /usr/share/nginx/html/  (컨테이너 내부는 절대 경로)
```

---

### ✓ 파일 권한 숫자 표기(예: 755, 644)가 어떤 규칙으로 결정되는가?

**확인 위치:** [README.md](README.md#L197-L200)

**권한 규칙:**

```
r (읽기) = 4
w (쓰기) = 2
x (실행) = 1
합계 = 권한 숫자
```

**각 자리수 의미:**
- 첫 번째 자리: 소유자(Owner)
- 두 번째 자리: 그룹(Group)
- 세 번째 자리: 기타(Others)

**실제 예시:**

```
755 = rwxr-xr-x (디렉토리/실행파일)
  7 = 4+2+1 = 소유자: 읽기+쓰기+실행
  5 = 4+1   = 그룹: 읽기+실행
  5 = 4+1   = 기타: 읽기+실행

644 = rw-r--r-- (텍스트 파일)
  6 = 4+2   = 소유자: 읽기+쓰기
  4 = 4     = 그룹: 읽기만
  4 = 4     = 기타: 읽기만

700 = rwx------ (개인 디렉토리)
  7 = 4+2+1 = 소유자: 모든 권한
  0 = 0     = 그룹: 권한 없음
  0 = 0     = 기타: 권한 없음

600 = rw------- (개인 파일)
  6 = 4+2   = 소유자: 읽기+쓰기
  0 = 0     = 그룹: 권한 없음
  0 = 0     = 기타: 권한 없음
```

**검증 명령:**
```bash
# 권한 변경 및 확인
chmod 755 perm_lab/dir1
ls -ld perm_lab/dir1  # drwxr-xr-x 표시

chmod 644 perm_lab/file1.txt
ls -l perm_lab/file1.txt  # -rw-r--r-- 표시

chmod 700 perm_lab/dir1
ls -ld perm_lab/dir1  # drwx------ 표시

chmod 600 perm_lab/file1.txt
ls -l perm_lab/file1.txt  # -rw------- 표시
```

---

## 4) 심층 인터뷰

### ✓ "호스트 포트가 이미 사용 중"이라 포트 매핑이 실패한다면, 어떤 순서로 원인을 진단할지 설명할 수 있는가?

**원인 진단 절차:**

1. **포트 사용 상태 확인**
   ```bash
   # macOS: 특정 포트 확인
   lsof -i :8080
   netstat -an | grep 8080
   
   # 더 자세한 정보
   ps aux | grep -i "8080\|docker"
   ```

2. **Docker 컨테이너 확인**
   ```bash
   # 실행 중인 컨테이너 리스트
   docker ps -a
   
   # 특정 포트 사용 컨테이너
   docker ps | grep "8080"
   ```

3. **기존 컨테이너 정리**
   ```bash
   # 같은 이름 컨테이너 확인
   docker ps -a | grep "mission-web-8080"
   
   # 기존 컨테이너 제거
   docker stop mission-web-8080
   docker rm mission-web-8080
   ```

4. **포트 매핑 재시도**
   ```bash
   # 다른 포트 사용 시도
   docker run -d --name mission-web-8090 -p 8090:80 mission-web:1.0
   
   # 또는 호스트 포트 변경
   docker run -d --name mission-web-alt -p 9000:80 mission-web:1.0
   ```

**예시 (실제 로그에서 발견):**
```bash
$ docker run -d --name mission-web-8080 -p 8080:80 mission-web:1.0
docker: Error response from daemon: Conflict. The container name "/mission-web-8080" is already in use...

$ docker ps -a | grep mission-web-8080
e0d872b08d08 ... mission-web-8080

$ docker rm -f mission-web-8080
mission-web-8080

$ docker run -d --name mission-web-8080 -p 8080:80 mission-web:1.0
# 성공
```

---

### ✓ 컨테이너 삭제 후 데이터가 사라진 경험이 있다면, 이를 방지하기 위한 대안을 설명할 수 있는가?

**문제 상황:**
```bash
# 컨테이너 내부 파일 작성
docker exec vol-no-test bash -lc "echo important-data > /tmp/data.txt"

# 컨테이너 삭제 시 데이터 손실
docker rm -f vol-no-test
# → /tmp/data.txt 영구 삭제
```

**대안 1: Docker 볼륨 사용** (권장)
```bash
# 이름 지정 볼륨 생성
docker volume create persistent_data

# 컨테이너에 볼륨 연결
docker run -d --name app1 -v persistent_data:/data ubuntu sleep infinity
docker exec app1 bash -lc "echo data > /data/keep.txt"

# 컨테이너 삭제
docker rm -f app1

# 다른 컨테이너에서 같은 볼륨 재연결
docker run -d --name app2 -v persistent_data:/data ubuntu sleep infinity
docker exec app2 bash -lc "cat /data/keep.txt"  # data 확인됨
```

**대안 2: 바인드 마운트 사용**
```bash
# 호스트 디렉토리에 직접 마운트
docker run -d --name web -v /Users/okbaronok23110/Desktop/data:/app/data nginx

# 호스트 /Users/.../data 에 저장되므로 컨테이너 삭제 후에도 유지
```

**대안 3: 정기적 백업**
```bash
# 컨테이너 내 데이터 호스트로 복사
docker cp running-container:/app/data ./backup/

# 재시작 시 복원
docker cp ./backup/data running-container-2:/app/data
```

**검증 (실제 스크린에서):**
```bash
# [mission/evidence/terminal.log](mission/evidence/terminal.log) 에서 확인
grep "docker volume create mission_data" mission/evidence/terminal.log
grep "docker exec vol-test-2 bash -lc 'cat /data/keep.txt'" mission/evidence/terminal.log
grep "persistent-data" mission/evidence/terminal.log
```

---

### ✓ 이 미션에서 가장 어려웠던 지점과, 해결 과정(가설 → 확인 → 조치)을 근거와 함께 설명할 수 있는가?

**확인 위치:** [README.md](README.md#L224-L242) (트러블슈팅 섹션)

**실제 사례들:**

#### 사례 1: 컨테이너 이름 충돌
**문제:** `docker run` 시 `Conflict. The container name ... is already in use` 발생

**가설:** 이전 실행에서 동일 이름 컨테이너가 이미 존재하고 정리되지 않음

**확인:**
```bash
docker ps -a | grep "mission-web-8080"  # 기존 컨테이너 발견
```

**조치:**
```bash
docker rm -f mission-web-8080
docker run -d --name mission-web-8080 -p 8080:80 mission-web:1.0
```

**근거:** [mission/evidence/terminal.log](mission/evidence/terminal.log) 에서 제1회 실행 성공, 제2회 실행 시 충돌 메시지 표시됨

---

#### 사례 2: 볼륨 미사용 시 데이터 유실
**문제:** 컨테이너 삭제 후 내부 파일이 사라짐

**가설:** 데이터가 컨테이너 레이어(COW)에만 저장되어 컨테이너 삭제 시 함께 제거됨

**확인:**
```bash
# 1차 컨테이너: 볼륨 연결 X
docker run -d --name test1 ubuntu sleep infinity
docker exec test1 bash -lc "echo data > /tmp/file.txt"
docker rm test1
# 데이터 손실 (restore 불가)

# 2차 컨테이너: 볼륨 사용
docker volume create mydata
docker run -d --name test2 -v mydata:/data ubuntu sleep infinity
docker exec test2 bash -lc "echo data > /data/file.txt"
docker rm test2

# 데이터 확인
docker run -d --name test3 -v mydata:/data ubuntu
docker exec test3 bash -lc "cat /data/file.txt"  # 데이터 유지 확인
```

**조치:** Docker 볼륨 사용 필수화

**근거:** [mission/evidence/terminal.log](mission/evidence/terminal.log) 에서 `persistent-data` 재확인 기록

---

#### 사례 3: 공유 셸 heredoc 대기 상태
**문제:** 긴 명령 실행 후 셸이 `heredoc>` 상태에 머물러 후속 명령 실패

**가설:** 미완성 heredoc 입력이 종료되지 않아 인터랙티브 모드 진입

**확인:**
```bash
# 문제 명령 (한 줄에 여러 명령)
docker run -d ... && echo 'text' > file.txt && docker run ...

# heredoc> 프롬프트 지속 → 셸 진행 안 됨
```

**조치:** 명령 분리 실행 및 파일 기반 처리
```bash
# ✓ 분리 실행
docker run -d --name web1 nginx
echo 'content' > file.txt
docker run -d --name web2 nginx

# ✓ 또는 스크립트 파일 사용
cat > run.sh << 'EOF'
docker run -d --name web nginx
echo 'done'
EOF
bash run.sh
```

**근거:** [mission/runlog.sh](mission/runlog.sh) 에서 명령 분리 패턴 사용

---

## 종합 평가 체크리스트

### 기능 동작 검증
- [x] 터미널 명령 확인 (`grep` 검색 가능)
- [x] 권한 변경 전/후 표시 (744 → 700/600)
- [x] Docker 버전/정보 출력
- [x] hello-world 실행
- [x] 이미지/컨테이너 목록 및 정리
- [x] Dockerfile 빌드
- [x] 포트 매핑 접속 (8080, 8081 curl 응답)
- [x] 볼륨 영속성 (persistent-data 재확인)
- [x] Git/GitHub 연동

### 문서/증거 완성도
- [x] README 기술 문서 (프로젝트개요/환경/체크리스트/검증/로그/원리/트러블슈팅)
- [x] 터미널 로그 ([mission/evidence/terminal.log](mission/evidence/terminal.log))
- [x] 스크린샷 증거 (web-8080, web-8081, web-8090, vscode-github)
- [x] 자동 점검 (`mission/check_submission.sh` PASS)

### 최종 상태
✅ **모든 평가 항목 충족 가능**
