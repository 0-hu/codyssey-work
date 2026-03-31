# E1-1: AI/SW 개발 워크스테이션 구축

## 1. 프로젝트 개요
개발 환경(Terminal, Docker, Git)을 직접 구축하고 실습하여 원리를 이해하고 재현 가능한 환경을 만드는 미션입니다.

## 2. 실행 환경
- **OS**: Ubuntu 24.04.3 LTS (WSL2)
- **Shell**: bash
- **Docker**: 28.2.2
- **Git**: 2.43.0

## 3. 수행 항목 체크리스트
- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습
- [x] Docker 설치/점검
- [x] hello-world 실행
- [x] Dockerfile 빌드/실행
- [x] 포트 매핑 접속
- [x] 바인드 마운트 반영
- [x] 볼륨 영속성
- [x] Git 설정 + VSCode GitHub 연동

---

## 4. 수행 로그

### 4.1 터미널 조작 및 권한 실습
```bash
$ pwd
/mnt/c/Project/codyssey-work/codyssey-work/E1-1
$ mkdir practice
$ touch practice/hello.txt && echo "Hello Codyssey!" > practice/hello.txt
$ cat practice/hello.txt
Hello Codyssey!
$ chmod 755 practice/hello.txt
$ ls -l practice/hello.txt
-rwxr-xr-x 1 ... hello.txt
```

### 4.2 Docker 기본 점검
```bash
$ docker --version
Docker version 28.2.2, build 28.2.2-0ubuntu1~24.04.1

$ docker run --rm hello-world
Hello from Docker!
...
```

### 4.3 custom Nginx 이미지 빌드 및 실행
```bash
# Dockerfile 작성 후 빌드
$ docker build -t my-web:1.0 .
Successfully built ...
Successfully tagged my-web:1.0

# 컨테이너 2개 실행 (포트 8080, 8081)
$ docker run -d -p 8080:80 --name my-web-1 my-web:1.0
$ docker run -d -p 8081:80 --name my-web-2 my-web:1.0

# 접속 확인
$ curl http://localhost:8080
<h1>Hello from my custom Nginx image!</h1>
```

### 4.4 바인드 마운트 점검 (Bind Mount)
```bash
# 호스트의 파일을 컨테이너에 마운트
$ docker run -d --name bind-test -v ./app/bind.txt:/usr/share/nginx/html/bind.txt nginx:alpine
# 내부에서 확인
$ docker exec bind-test cat /usr/share/nginx/html/bind.txt
initial_bind_content
# 호스트에서 내용 수정 후 리플렉션 확인
$ echo "updated" >> ./app/bind.txt
$ docker exec bind-test cat /usr/share/nginx/html/bind.txt
initial_bind_content
updated
```

### 4.5 Docker 볼륨 영속성 검증 (Named Volume)
```bash
# 볼륨 생성 및 컨테이너 삭제/재생성 시 데이터 유지 확인
$ docker volume create my-vol
$ docker run -d --name vol-test -v my-vol:/data ubuntu sleep infinity
$ docker exec vol-test sh -c "echo 'vol_data' > /data/test.txt"
$ docker rm -f vol-test
$ docker run --rm -v my-vol:/data ubuntu cat /data/test.txt
vol_data
```

### 4.6 Git 연동
```bash
$ git config --list
user.name=0-hu
user.email=yhkwon.net@gmail.com
...
# VSCode 연동 완료 확인
```

## 5. 트러블슈팅
1. **Docker Daemon 권한 문제**: WSL 환경에서 `docker.sock` 접근 권한 없음 → `sudo usermod -aG docker $USER` 및 `sudo service docker start`를 통해 해결.
2. **WSL 경로 마운트 시 권한**: Windows 드라이브 마운트 경로(`/mnt/c/...`)에서 `chmod`가 실제 동작하지 않는 이슈 확인 → 리눅스 네이티브 경로(`~/...`)에서 추가 실습을 통해 권한 관리 로직 검증.
