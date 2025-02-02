# aihubshell Docker 이미지 (비공식) 🚀

AI Hub에서 **CLI**로 데이터를 다운로드할 수 있는 툴인 `aihubshell`을 Docker로 간단히 실행할 수 있도록 구성한 **비공식** 이미지입니다.  
본 이미지는 `Alpine Linux` 기반으로 제작되었으며, 사용 전에 **AI Hub** 이용 약관을 반드시 숙지하고, 데이터셋 다운로드 승인 여부 등을 **사전에 확인**한 후 사용해주세요.


## 📚 목차
1. [개요](-#개요)  
2. [이미지 가져오기](-#이미지-가져오기)  
3. [컨테이너 실행](-#컨테이너-실행)  
4. [docker-compose 사용](-#docker-compose-사용)  
5. [사용 예시](-#사용-예시)  
6. [주의사항](-#주의사항)  
7. [보안 및 법적 고지](-#보안-및-법적-고지)  
8. [라이선스](-#라이선스)


## 💡 개요
[AI Hub](https://aihub.or.kr)에서 제공하는 학습용 데이터는 **aihubshell** 유틸리티를 통해 터미널(명령줄)에서 간단히 다운로드할 수 있습니다.  
본 저장소에서는 `aihubshell`이 **미리 설치**된 Docker 이미지를 제공함으로써:

- **설치 편의성**: 별도 구성 없이 `docker pull` 후 바로 사용  
- **환경 격리**: 호스트 OS에 영향 없이 동일한 환경 보장  
- **이식성**: Windows, Mac, Linux 등 어디에서나 일관된 실행 가능  

### Dockerfile 주요 내용(요약)
```dockerfile
FROM alpine:latest

RUN apk update && apk add --no-cache curl unzip

RUN curl -o "aihubshell" https://api.aihub.or.kr/api/aihubshell.do \
    && chmod +x aihubshell \
    && cp aihubshell /usr/bin

ENTRYPOINT ["/bin/sh"]
```
- `apk add`를 통해 `curl`과 `unzip` 설치  
- `aihubshell` 다운로드 및 실행 권한 부여  


## 📥 이미지 가져오기
이미 **빌드된 이미지를 GHCR**에서 직접 받아 사용할 수 있습니다.

```bash
docker pull ghcr.io/jjh4450/aihubshell_unofficial:latest
```
> 원하시는 다른 버전 태그가 있다면 `:latest` 대신 해당 태그를 지정하세요.
>
> 이 이미지는 외부 의존성이 적고 매주 자동 업데이트되어 **`:latest` 태그 사용을 권장합니다.**

## ⚡ 컨테이너 실행

### 1) 간단 실행
```bash
docker run -it --rm \
  ghcr.io/jjh4450/aihubshell_unofficial:latest
```
- `-it`: 터미널 상호작용(인터랙티브) 모드  
- `--rm`: 컨테이너 종료 시 자동 제거  

컨테이너 내부로 접속되면 `sh` 셸을 통해 `aihubshell` 명령어를 바로 입력할 수 있습니다:
```bash
aihubshell -mode l
# AI Hub 데이터셋 목록 조회
```

### 2) `aihubshell` 명령어 바로 실행
```bash
docker run -it --rm \
  ghcr.io/jjh4450/aihubshell_unofficial:latest \
  aihubshell -mode l # 원하는 명령어 입력 가능
```


## 🤝 docker-compose 사용

볼륨 마운트를 통해 **호스트 디렉토리**에 데이터를 저장하고 싶다면, 예시와 같은 `docker-compose.yml`을 사용할 수 있습니다.

```yaml
version: "3.8"

services:
  aihub:
    image: ghcr.io/jjh4450/aihubshell_unofficial:latest
    container_name: aihubshell_container
    volumes:
      - <your_dir>:/data  # 호스트의 경로를 컨테이너 내부 /data(default)에 연결
```

이후 다음 명령어로 컨테이너를 실행합니다:
```bash
docker-compose up -d
# 백그라운드 모드 실행

docker exec -it aihubshell_container sh
# 실행 중인 컨테이너에 접속 (터미널)
```
이제 컨테이너 내부에서 `aihubshell` 명령어를 사용할 수 있으며, `/data`에 다운로드된 파일은 호스트의 `./data` 디렉토리에서 확인 가능합니다.


## 📝 사용 예시

### 1) 데이터셋 목록 조회
```bash
aihubshell -mode l
```
- 출력되는 목록에서 `datasetkey`를 확인할 수 있습니다.

### 2) 전체 다운로드
```bash
aihubshell -mode d \
  -datasetkey <데이터셋KEY> \
  -aihubid 'AIHUB_아이디' \
  -aihubpw 'AIHUB_비밀번호'
```
- 해당 데이터셋에 대한 다운로드 승인(승인신청 후)이 이미 완료되어 있어야 합니다.

### 3) 특정 파일 다운로드
```bash
aihubshell -mode d \
  -datasetkey <데이터셋KEY> \
  -filekey <파일KEY1,파일KEY2,...> \
  -aihubid 'AIHUB_아이디' \
  -aihubpw 'AIHUB_비밀번호'
```
- `,`로 여러 개의 `filekey`를 구분하여 선택 다운로드가 가능합니다.

### 4) 저장 경로 지정
```bash
aihubshell -mode d \
  -datasetkey <데이터셋KEY> \
  -aihubid 'AIHUB_아이디' \
  -aihubpw 'AIHUB_비밀번호' \
  -o /data
```
- `/data` 디렉토리에 저장하여 호스트의 `./data`에서 확인할 수 있습니다.


## ⚠️ 주의사항

1. **AI Hub 이용 약관**  
   - `aihubshell`은 AI Hub 공식 API와 연동되므로, 사용 전 반드시 [AI Hub 이용 약관](https://aihub.or.kr)을 준수하세요.

2. **데이터 승인**  
   - 데이터셋 다운로드 전 해당 데이터셋에 대해 **다운로드 승인이 완료**되어 있어야 합니다.

3. **특수문자 비밀번호**  
   - `-aihubid` 또는 `-aihubpw` 인수에 특수문자가 포함된 경우, **홑따옴표**(`'...'`)로 감싸 입력하세요.

4. **디스크 여유 공간**  
   - 압축된 데이터셋 용량이 큰 경우, 최소 2~3배 이상의 디스크 용량을 확보하시기 바랍니다.

5. **데이터 보존**  
   - Docker 컨테이너 내부 스토리는 컨테이너 종료와 함께 사라집니다.  
   - 다운로드된 파일을 영구적으로 보관하려면, **호스트 볼륨 마운트**(예: `-v ./data:/data`)를 권장합니다.


## 🔒 보안 및 법적 고지
1. **보안 책임**  
   - 본 이미지는 단순히 `aihubshell`을 실행하기 위한 환경을 제공할 뿐,  
     **사용자의 인증 정보(아이디/비밀번호) 보안을 완전히 보장하지 않습니다.**  
   - 민감 정보는 환경변수나 직접 입력 시 주의하세요.

2. **법적 책임 한계**  
   - 본 이미지는 AI Hub와 공식적인 관계가 없는 **비공식** 프로젝트입니다.  
   - 본 이미지를 사용함으로써 발생할 수 있는 **법적 문제, 데이터 손실, 기타 피해** 등은 전적으로 사용자의 책임입니다.  
   - **AI Hub 데이터** 사용에 따른 모든 책임(저작권, 개인정보보호, 보안 등)은 최종적으로 **사용자**에게 있습니다.  
   - Dockerfile 및 예제 코드는 참고용이며, **사용 시 발생하는 문제에 대해 어떠한 책임도 지지 않습니다.**

3. **취약점 가능성**  
   - `Alpine Linux` 최소 환경에서 기본 패키지만을 설치하였으며,  
     추가적인 보안 설정(방화벽, IDS 등)은 제공하지 않습니다.  
   - 필요한 보안 강화 조치는 **사용자**가 직접 진행해야 합니다.


## 📜 라이선스

- **Dockerfile 및 예제 코드**: [MIT License](LICENSE)  
- **`aihubshell` 유틸리티**: [AI Hub 정책](https://aihub.or.kr)에 따름  

> 문의  
> - **AI Hub 데이터 다운로드/정책**: [AI Hub](https://aihub.or.kr)  
> - **Docker 이미지 이슈**: GitHub Issue로 제보  

**즐거운 AI Hub 데이터 다운로드 되세요!** ☺️  
[ghcr.io/jjh4450/aihubshell_unofficial:latest](https://github.com/jjh4450?tab=packages)  
