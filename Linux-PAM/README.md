# 🔐 PAM을 이용한 비밀번호 정책 규제

![PAM](https://img.shields.io/badge/PAM-Pluggable%20Authentication%20Modules-brightgreen)
![Linux](https://img.shields.io/badge/Linux-Operating%20System-blue)

## 📝 미션

**PAM (Pluggable Authentication Modules)** 을 사용하는 리눅스 시스템에서 사용자의 인증을 담당하는 모듈을 통해 **비밀번호를 8자리 이상으로 규제**

<br>

## 📚 PAM(Pluggable Authentication Modules) 간략 설명

**PAM(Pluggable Authentication Modules)** 은 리눅스 및 유닉스 계열 운영체제에서 인증 방식을 유연하게 관리할 수 있도록 설계된 프레임워크입니다. PAM을 통해 시스템 관리자나 개발자는 다양한 인증 방식을 모듈화된 형태로 손쉽게 추가, 제거, 구성할 수 있습니다.

### 🔑 PAM의 주요 특징

- **모듈화(Modularity):** 인증, 계정 관리, 세션 관리, 비밀번호 관리 등의 작업을 개별 모듈로 분리하여 관리.
- **유연성(Flexibility):** 설정 파일을 통해 원하는 모듈을 선택하고, 실행 순서를 지정할 수 있음.
- **확장성(Scalability):** 새로운 인증 방식을 쉽게 추가하거나 기존 방식을 변경할 수 있음.
- **통합성(Integration):** 다양한 서비스(예: SSH, sudo, 로그인 등)에서 공통된 인증 프레임워크를 사용하여 일관된 보안 정책을 유지.
  <br>

## 🔧 해결 방법

### 1️⃣ 1단계: 루트 권한 확보

비밀번호 정책을 변경하려면 루트 권한이 필요합니다.

```bash
sudo -i
```

### 2️⃣ 2단계: 필요한 PAM 모듈 설치 확인

pam_pwquality 모듈이 설치되어 있는지 확인하고, 설치되지 않은 경우 설치합니다.

```bash
sudo apt update
sudo apt install libpam-pwquality
```

### 3️⃣ 3단계: PAM 설정 파일 수정

3.1. 기존 설정 파일 백업<br>
설정 파일을 수정하기 전에 백업을 생성합니다.

```bash
sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
```

3.2. common-password 파일 편집

```bash
sudo vim /etc/pam.d/common-password
```

3.3. pam_pwquality.so 설정 수정<br/>
pam_pwquality.so 모듈의 설정을 수정하여 **최소 비밀번호 길이를 8자리**로 설정합니다.

```bash
password        requisite       pam_pwquality.so retry=3 minlen=8
```

- 옵션 설명

  - retry=3: 비밀번호 입력 실패 시 재시도 횟수
  - minlen=8: 최소 비밀번호 길이를 8자리로 설정

- 추가 옵션 (선택 사항)<br>
  비밀번호의 복잡성을 강화하기 위해 추가적인 옵션을 설정할 수 있습니다.

```bash
password        requisite       pam_pwquality.so retry=3 minlen=8 dcredit=-1 ucredit=-1 ocredit=-1 lcredit=-1
```

- 추가 옵션 설명
  - dcredit=-1: 최소 하나의 숫자 포함
  - ucredit=-1: 최소 하나의 대문자 포함
  - ocredit=-1: 최소 하나의 특수 문자 포함
  - lcredit=-1: 최소 하나의 소문자 포함

### 4️⃣ 4단계: 정책 테스트

비밀번호 정책이 제대로 적용되었는지 확인하기 위해 새 사용자를 생성하고, 비밀번호를 설정합니다.

```bash
# 새 사용자 생성
sudo adduser testuser
# 비밀번호 설정
sudo passwd testuser
```

비밀번호를 설정할 때, 8자리 미만의 비밀번호를 입력하면 거부되어야 합니다.
