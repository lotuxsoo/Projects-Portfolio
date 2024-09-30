# 🐳 Docker 이미지 빌드 및 실행 for Java Application

Docker는 애플리케이션의 개발, 테스트, 배포를 간편하게 해주는 강력한 도구입니다. 이 문서에서는 간단한 Java 애플리케이션을 Docker 이미지로 빌드하고 실행하는 과정을 단계별로 안내합니다.

## 목차

1. [사전 준비 사항](#1-사전-준비-사항)
2. [프로젝트 디렉토리 설정](#2-프로젝트-디렉토리-설정)
3. [Java 애플리케이션 작성](#3-java-애플리케이션-작성)
4. [Dockerfile 작성](#4-dockerfile-작성)
5. [Docker 이미지 빌드](#5-docker-이미지-빌드)
6. [Docker 컨테이너 실행](#6-docker-컨테이너-실행)
7. [Docker 이미지 푸시 (선택)](#7-docker-이미지-푸시-선택)
8. [Docker 이미지를 최적화하는 방법](#8-docker-이미지를-최적화하는-방법)
   1. [더 작은 Base 이미지 사용](#1-더-작은-base-이미지-사용)
   2. [멀티 스테이지 빌드 활용](#2-멀티-스테이지-빌드-활용)
   3. [불필요한 레이어 수 줄이기](#3-불필요한-레이어-수-줄이기)
   4. [Production Dependencies만 설치](#4-production-dependencies만-설치)
   5. [불필요한 패키지 설치하지 않기](#5-불필요한-패키지-설치하지-않기)
   6. [apt 캐시 삭제](#6-apt-캐시-삭제)
   7. [.dockerignore 활용하기](#7dockerignore-활용하기)
   8. [애플리케이션 데이터를 별도 볼륨으로 분리](#8-애플리케이션-데이터를-별도-볼륨으로-분리)

## 1. 사전 준비 사항

Docker 이미지를 빌드하고 실행하기 전에 다음 도구들이 설치되어 있어야 합니다.

- **Docker:** Docker는 컨테이너를 관리하는 플랫폼입니다. [Docker 설치 가이드](https://docs.docker.com/get-docker/)를 참고하여 Docker를 설치하세요.
- **Java Development Kit (JDK):** Java 애플리케이션을 컴파일하기 위해 필요합니다. [JDK 설치](https://www.oracle.com/java/technologies/javase-jdk17-downloads.html) 가이드를 참고하세요.

## 2. 프로젝트 디렉토리 설정

작업할 프로젝트 디렉토리를 생성하고 해당 디렉토리로 이동합니다.

```bash
# 원하는 위치로 이동 (예: 홈 디렉토리)
cd ~

# 프로젝트 디렉토리 생성
mkdir my-java-app

# 디렉토리로 이동
cd my-java-app
```

## 3. Java 애플리케이션 작성

간단한 Java 프로그램을 작성하여 Docker 이미지에 포함시킬 것입니다. 예를 들어, "Hello, Docker!"를 출력하는 프로그램을 만들어 보겠습니다.

### 3.1. `Main.java` 파일 생성

```java
// Main.java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, Docker!");
    }
}
```

### 3.2. 파일 생성 방법

터미널을 사용하여 `Main.java` 파일을 생성하고 편집할 수 있습니다.

```bash
# Main.java 파일 생성 및 편집 (nano 사용 예시)
nano Main.java
```

`nano` 에디터가 열리면 위의 Java 코드를 붙여넣고 `Ctrl + O`를 눌러 저장한 후 `Ctrl + X`로 종료합니다.

## 4. Dockerfile 작성

Docker 이미지를 빌드하기 위한 `Dockerfile`을 작성합니다. `Dockerfile`은 이미지의 빌드 과정을 정의하는 파일입니다.

### 4.1. `Dockerfile` 내용

```bash
# 베이스 이미지 설정 (OpenJDK 17 사용)
FROM openjdk:17

# 애플리케이션 소스 복사
COPY . /usr/src/myapp

# 작업 디렉토리 설정
WORKDIR /usr/src/myapp

# 소스 컴파일
RUN javac Main.java

# 컨테이너 실행 시 실행할 명령어
CMD ["java", "Main"]
```

### 4.2. 파일 생성 방법

터미널을 사용하여 `Dockerfile`을 생성하고 편집할 수 있습니다.

```bash
# Dockerfile 생성 및 편집 (nano 사용 예시)
nano Dockerfile
```

위의 `Dockerfile` 내용을 붙여넣고 `Ctrl + O`로 저장한 후 `Ctrl + X`로 종료합니다.

## 5. Docker 이미지 빌드

이제 준비된 `Main.java`와 `Dockerfile`을 바탕으로 Docker 이미지를 빌드합니다.

### 5.1. 빌드 명령어

```bash
docker build -t my-java-app .
```

### 5.2. 명령어 설명

- **`docker build`**: Docker 이미지를 빌드하는 명령어입니다.
- **`-t my-java-app`**: 생성될 이미지에 `my-java-app`이라는 태그를 지정합니다. 태그는 이미지 이름을 식별하는 데 사용됩니다.
- **`.` (마침표)**: 현재 디렉토리를 빌드 컨텍스트로 지정합니다. Docker는 이 디렉토리 내의 `Dockerfile`을 찾아 이미지를 빌드합니다.

### 5.3. 빌드 과정 확인

명령어를 실행하면 Docker가 `Dockerfile`의 각 명령어를 순차적으로 실행하며 이미지를 빌드합니다. 예시 출력은 다음과 같습니다:

```bash
Sending build context to Docker daemon  3.072kB
Step 1/5 : FROM openjdk:17
 ---> a1b2c3d4e5f6
Step 2/5 : COPY . /usr/src/myapp
 ---> Using cache
 ---> b2c3d4e5f6a7
Step 3/5 : WORKDIR /usr/src/myapp
 ---> Using cache
 ---> c3d4e5f6a7b8
Step 4/5 : RUN javac Main.java
 ---> Running in d4e5f6a7b8c9
Removing intermediate container d4e5f6a7b8c9
 ---> e5f6a7b8c9d0
Step 5/5 : CMD ["java", "Main"]
 ---> Running in f6a7b8c9d0e1
Removing intermediate container f6a7b8c9d0e1
 ---> a7b8c9d0e1f2
Successfully built a7b8c9d0e1f2
Successfully tagged my-java-app:latest
```

빌드가 성공적으로 완료되면 `my-java-app:latest`라는 태그가 있는 이미지가 생성됩니다.

## 6. Docker 컨테이너 실행

빌드한 이미지를 기반으로 컨테이너를 실행하여 Java 애플리케이션을 테스트합니다.

### 6.1. 실행 명령어

```bash
docker run --rm my-java-app
```

### 6.2. 명령어 설명

- **`docker run`**: Docker 컨테이너를 실행하는 명령어입니다.
- **`--rm`**: 컨테이너가 종료되면 자동으로 삭제되도록 합니다.
- **`my-java-app`**: 실행할 Docker 이미지의 이름입니다.

### 6.3. 실행 결과

```bash
Hello, Docker!
```

"Hello, Docker!"가 출력되면 성공적으로 컨테이너가 실행된 것입니다.

## 7. Docker 이미지 푸시 (선택)

빌드한 이미지를 Docker Hub와 같은 원격 레지스트리에 업로드하여 다른 사람들과 공유하거나 다른 환경에서 사용할 계획이라면, 다음 단계를 따릅니다.

### 7.1 Docker Hub 계정 생성 및 로그인

먼저, Docker Hub에 계정을 생성하고 로그인합니다.

```bash
# Docker Hub 로그인
docker login
```

### 7.2 이미지 태깅

Docker Hub에 이미지를 푸시하려면 이미지 이름을 `username/repository:tag` 형식으로 지정해야 합니다.
예를 들어, Docker Hub 사용자 이름이 `yourusername`이라면:

```bash
# 기존 이미지에 새로운 태그 추가
docker tag myimg1 yourusername/myimg1:latest
```

### 7.3 이미지 푸시

태그가 지정된 이미지를 Docker Hub로 푸시합니다.

```bash
docker push yourusername/myimg1:latest
```

푸시가 완료되면 Docker Hub에서 이미지를 확인할 수 있습니다.

### 7.4 원격 레지스트리에서 이미지 풀링 및 실행

다른 환경에서 이미지를 사용하려면 Docker Hub에서 이미지를 풀링(pull)하고 실행할 수 있습니다.

```bash
# 이미지 풀링
docker pull yourusername/myimg1:latest

# 이미지 실행
docker run --rm yourusername/myimg1:latest
```

## 8. 결론

이제 간단한 Java 애플리케이션을 Docker 이미지로 빌드하고 실행하는 과정을 완료했습니다. 이 과정을 통해 Docker의 기본적인 사용법을 이해할 수 있으며, 이후 이미지 최적화 및 배포 단계로 넘어갈 준비가 되었습니다.

<br>

# 🤔 Docker 이미지를 최적화하는 방법

Docker 이미지를 최적화하면 용량을 줄이고 빌드 및 배포 속도를 향상시킬 수 있습니다. 아래 방법들을 참고하여 효율적인 Docker 이미지를 만들 수 있습니다.
![image](https://github.com/user-attachments/assets/03242ea9-e0e4-40a5-aa76-ce6ab0f21ad4)

### 1. 더 작은 Base 이미지 사용

Base 이미지는 기본 환경을 제공하지만 불필요한 패키지가 포함될 수 있습니다. 작은 Base 이미지를 사용하여 이미지 크기를 줄일 수 있습니다.

**예시:**

- `openjdk:17-jdk-slim` (약 400MB)
- `adoptopenjdk:17-jdk-hotspot-focal` (약 350MB)
- `openjdk:17-alpine` (약 200MB) _(주의: Alpine 기반 이미지는 일부 Java 애플리케이션에서 호환성 문제가 발생할 수 있습니다.)_

**주의사항:** 경량화된 이미지는 필요한 패키지나 파일이 누락될 수 있으므로 애플리케이션 요구사항을 충족하는지 확인해야 합니다.

### 2. 멀티 스테이지 빌드 활용

멀티 스테이지 빌드를 사용하면 빌드 단계와 실행 단계를 분리하여 최종 이미지에 불필요한 파일을 포함하지 않을 수 있습니다.

```bash
# 빌드 단계
FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app

# 의존성 복사 및 다운로드
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사 및 빌드
COPY src ./src
RUN mvn package -DskipTests

# 실행 단계
FROM openjdk:17-jdk-slim

WORKDIR /app

# 빌드 결과물 복사
COPY --from=build /app/target/myapp.jar /app/myapp.jar

# 애플리케이션 실행
CMD ["java", "-jar", "myapp.jar"]
```

### 3. 불필요한 레이어 수 줄이기

각 `RUN`, `COPY`, `FROM` 명령어는 새로운 레이어를 생성합니다. 관련 명령어를 하나의 `RUN`으로 결합하여 레이어 수를 줄이세요.

비효율적 예시:

```bash
FROM ubuntu:latest

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install vim net-tools dnsutils -y
```

최적화 예시:

```bash
FROM ubuntu:latest

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y vim net-tools dnsutils && \
    rm -rf /var/lib/apt/lists/*
```

### 4. Production Dependencies만 설치

빌드 시 개발용 패키지는 필요하지 않으므로, Production Dependencies만 설치하여 이미지 크기를 줄입니다.

Maven 예시:

```bash
FROM maven:3.8.6-openjdk-17 AS build

WORKDIR /app

# 의존성 복사 및 다운로드
COPY pom.xml .
RUN mvn dependency:go-offline -B

# 소스 코드 복사 및 빌드
COPY src ./src
RUN mvn package -DskipTests
```

Gradle 예시:

```bash
FROM gradle:7.6.1-jdk17 AS build

WORKDIR /app

# 의존성 복사 및 다운로드
COPY build.gradle settings.gradle ./
RUN gradle build -x test --no-daemon

# 소스 코드 복사 및 빌드
COPY src ./src
RUN gradle build -x test --no-daemon
```

### 5. 불필요한 패키지 설치하지 않기

패키지를 설치할 때 불필요한 권장 패키지를 설치하지 않도록 합니다.

```bash
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat && \
    rm -rf /var/lib/apt/lists/*
```

### 6. apt 캐시 삭제

``apt-get`을 사용한 후 캐시를 삭제하여 이미지 용량을 줄입니다.

```bash
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat && \
    rm -rf /var/lib/apt/lists/*
```

### 7. `.dockerignore` 활용하기

`.dockerignore` 파일을 사용하여 빌드 컨텍스트에 불필요한 파일을 제외합니다. 이를 통해 빌드 시간을 단축하고 이미지 크기를 줄일 수 있습니다.

```bash
# .dockerignore
target/
*.log
*.tmp
.git
```

### 8. 애플리케이션 데이터를 별도 볼륨으로 분리

애플리케이션 데이터를 이미지에 포함시키지 않고 별도의 볼륨으로 분리하면 이미지 크기를 줄일 수 있습니다. 볼륨은 컨테이너 재시작이나 이미지 업그레이드 시에도 데이터를 유지합니다.

```bash
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/myapp.jar /app/myapp.jar

# 데이터 디렉토리를 볼륨으로 설정
VOLUME /app/data

# 애플리케이션 실행
CMD ["java", "-jar", "myapp.jar"]
```

이러한 최적화 방법들을 통해 Docker 이미지를 보다 효율적이고 관리하기 쉽게 만들 수 있습니다. 최적화된 이미지는 배포 속도를 높이고, 비용을 절감하며, 전반적인 애플리케이션 운영 효율성을 향상시킵니다.
