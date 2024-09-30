# 🔒 Trivy를 활용한 보안 테스트 🔒

## 📑 개요
**보안 취약점의 탐지**는 애플리케이션 개발과 배포의 모든 단계에서 중요한 부분을 차지합니다. 특히, 컨테이너화된 애플리케이션이나 Maven과 같은 빌드 도구를 사용하는 Java 프로젝트에서는, 보안 스캔 도구를 통해 알려진 취약점을 사전에 탐지하고 대응하는 것이 필수적입니다. 저희는 **OWASP Juice Shop Docker 이미지**와 **Maven 기반 Java 프로젝트**에서 **Trivy를 활용하여 보안 취약점을 탐지하는 방법**과 그 결과를 분석하였습니다.<br><br>
**🔎Trivy**: 컨테이너 이미지, 파일 시스템, 및 Git 리포지토리에서 보안 취약점을 탐지하는 경량화된 오픈 소스 도구입니다. 특히, Trivy는 소프트웨어 구성 요소의 보안 취약점뿐만 아니라 설정 파일의 잘못된 설정도 탐지할 수 있습니다.<br/>

**🧃OWASP Juice Shop**: 다양한 보안 취약점을 의도적으로 포함한 웹 애플리케이션으로, 보안 교육 및 보안 도구의 테스트를 위해 설계되었습니다. 이번 테스트에서는 OWASP Juice Shop의 Docker 이미지를 대상으로 Trivy를 사용하여 보안 취약점을 스캔하고 분석합니다.

## 🎯 학습 목표
- **OWASP Juice Shop과 Maven 프로젝트의 보안 취약점 탐지 이해**: Trivy를 활용하여 Docker 이미지 및 Maven 프로젝트에서 보안 취약점을 탐지하는 방법을 학습합니다.
- **Trivy 설치 및 활용**: Trivy를 설치하고, Docker 이미지를 대상으로 보안 스캔을 수행하는 방법을 학습합니다.
- **보안 취약점 분석**: Trivy를 사용하여 OWASP Juice Shop Docker 이미지에서 발견된 보안 취약점을 분석하고, 그 심각성과 영향을 평가합니다.
- **취약점 대응 방안 마련**: 발견된 보안 취약점을 해결하기 위한 구체적인 조치를 제안하고, 이를 통해 애플리케이션 보안성을 향상시키는 방법을 학습합니다.

## 👩‍👩‍👧‍👧 팀원
| <img src="https://avatars.githubusercontent.com/u/84564138?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/127733525?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/86272865?v=4" width="150" height="150"/> | <img src="https://avatars.githubusercontent.com/u/65701100?v=4" width="150" height="150"/> |
|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|:-------------------------------------------------------------------------------------------:|:------------------------------------------------------------------------------------------:|
|                     **노솔리** <br/>[@soljjang777](https://github.com/soljjang777)                     |                      **구동길**<br/>[@dkac0012](https://github.com/dkac0012)                      |                     **최수연**<br/>[@lotuxsoo](https://github.com/lotuxsoo)                      |                 **홍민영** <br/>[@HongMinYeong](https://github.com/HongMinYeong)                 |                         |
<br>

## 🧪 시나리오 1: OWASP Juice Shop Docker 이미지 보안 테스트

### **OWASP Juice Shop Docker 이미지 설정**

먼저 OWASP Juice Shop Docker 이미지를 다운로드하고 실행합니다:
```bash
# Docker를 사용하여 OWASP Juice Shop 컨테이너 실행
docker run -d --name juice-shop -p 3000:3000 bkimminich/juice-shop
```
- **-d**: 컨테이너를 백그라운드에서 실행.
- **--name juice-shop**: 컨테이너의 이름을 "juice-shop"으로 지정.
- **-p 3000:3000**: 호스트 시스템의 포트 3000을 컨테이너의 포트 3000에 매핑.

이 명령어로 Juice Shop이 실행되며, 웹 브라우저에서 `http://localhost:3000`으로 접근할 수 있습니다.

### **Trivy 설치**

Trivy가 설치되어 있지 않다면, 아래의 명령어를 사용하여 설치합니다.
- **Mac**:
```bash
brew install aquasecurity/trivy/trivy
```

- **Ubuntu**:
```bash
sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
```

### **Trivy로 OWASP Juice Shop 스캔**

Docker로 실행 중인 Juice Shop 이미지를 Trivy로 스캔하여 보안 취약점을 탐지합니다:
```bash
# Juice Shop Docker 이미지 스캔
trivy image bkimminich/juice-shop
```

이 명령어는 Juice Shop 이미지에서 발견된 보안 취약점들을 나열합니다. Trivy는 알려진 취약점을 기반으로 보안 경고를 표시하며, 결과는 다음과 같이 출력됩니다:
```shell
2024-09-25T00:00:00Z [INFO] Detected OS: node
2024-09-25T00:00:00Z [INFO] Detecting node vulnerabilities...
...
Total: 25 (UNKNOWN: 0, LOW: 5, MEDIUM: 10, HIGH: 8, CRITICAL: 2)
```

### **상세한 보고서 생성 (옵션)**

Trivy는 기본 텍스트 출력 외에도 JSON, HTML 등 다양한 포맷으로 보고서를 생성할 수 있습니다. 아래 명령어를 사용하여 JSON 포맷의 보고서를 생성할 수 있습니다:
```bash
# JSON 포맷으로 보고서 생성
trivy image --format json -o juice-shop-report.json bkimminich/juice-shop
```

## **🔎 발견된 보안 취약점 분석**

OWASP Juice Shop 이미지 스캔 결과, 총 4개의 주요 보안 취약점이 발견되었습니다. 이들 중 일부는 **JWT 토큰**과 **비대칭 암호화 키**와 관련된 중요한 보안 이슈를 포함하고 있습니다.

### **1. JWT 토큰 노출 (Medium Severity)**

- **파일 경로**:
    
    - `/juice-shop/frontend/src/app/app.guard.spec.ts`
    - `/juice-shop/frontend/src/app/last-login-ip/last-login-ip.component.spec.ts`
- **설명**:
    
    - JWT(Json Web Token) 토큰이 코드 내부에 하드코딩되어 있으며, 이는 보안상 매우 위험한 행위입니다. 악의적인 사용자가 토큰을 획득하면 이를 통해 사용자의 세션을 탈취하거나 인증된 사용자인 것처럼 행동할 수 있습니다.
- **조치 방안**:
    
    - JWT 토큰을 코드 내부에 하드코딩하지 않도록 수정해야 합니다. 테스트 목적으로 필요한 경우, 안전한 방식으로 토큰을 주입하거나 환경 변수를 사용하는 방법을 고려할 수 있습니다.

### **2. 비대칭 암호화 키 노출 (High Severity)**

- **파일 경로**:
    
    - `/juice-shop/lib/insecurity.ts`
    - `/juice-shop/build/lib/insecurity.js`
- **설명**:
    
    - RSA 비대칭 암호화의 개인 키(private key)가 코드에 하드코딩되어 노출되었습니다. 이로 인해 악의적인 사용자가 개인 키를 이용해 암호화된 데이터를 복호화하거나 위조할 수 있는 가능성이 생깁니다.
- **조치 방안**:
    
    - 개인 키는 절대로 코드에 하드코딩되어서는 안 됩니다. 이를 안전한 키 관리 시스템 또는 환경 변수 등을 통해 관리해야 합니다. 이미 노출된 키는 즉시 폐기하고 새로운 키를 생성하여 사용하는 것이 필요합니다.
<br>

## 🧪 시나리오 2: Maven 프로젝트에서 취약점 검출 (Java 파일의 취약점 검사)

### 1. Maven 프로젝트 파일 생성

#### **Maven 프로젝트 구조**

먼저, 간단한 Maven 프로젝트를 생성하고 다음과 같은 디렉터리 구조를 설정합니다:

```bash
my-java-project/
│
├── src/
│   └── main/
│       └── java/
│           └── com/
│               └── example/
│                   └── App.java
├── pom.xml
└── README.md
```
#### pom.xml 파일
```
<project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>my-java-project</groupId>
  <artifactId>my-java-project</artifactId>
  <version>0.0.1-SNAPSHOT</version>
  <build>
    <sourceDirectory>src</sourceDirectory>
    <plugins>
      <plugin>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <release>17</release>
        </configuration>
      </plugin>
    </plugins>
  </build>
  
  <dependencies>
    <!-- 취약점이 있는 라이브러리 버전 -->
    <dependency>
        <groupId>commons-collections</groupId>
        <artifactId>commons-collections</artifactId>
        <version>3.2.1</version> <!-- 이 버전에는 알려진 취약점이 있습니다 -->
    </dependency>
</dependencies>

</project>
```
#### Java 파일
```java
package main.java.com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello, Trivy!");
    }
}

```
### 2. Maven 프로젝트 Trivy로 검사
이제 Trivy를 사용하여 Maven 프로젝트의 취약점을 검사합니다:
```bash
$ ls
my-java-project

$ trivy fs --scanners vuln my-java-project 
```
이 명령어를 실행하면, Trivy는 프로젝트에서 사용된 모든 종속성을 검사하여 알려진 보안 취약점을 탐지합니다.<br>

<img src="https://github.com/user-attachments/assets/a388224f-8279-4c08-bb12-2c5d40327c50" width="850">

### **3. 결과 분석**

Trivy는 `commons-collections` 라이브러리의 취약 버전을 감지하여 보안 경고를 표시합니다. 이 라이브러리의 특정 버전(3.2.1)은 **원격 코드 실행 취약점**(CVE-2015-6420)을 포함하고 있으며, Trivy는 이를 최신 버전으로 업데이트해야 한다는 정보를 제공합니다.

- 관련 CVE:
    - [CVE-2015-7501](https://nvd.nist.gov/vuln/detail/cve-2015-7501)
    - [CVE-2015-6420](https://nvd.nist.gov/vuln/detail/CVE-2015-6420)

## **✨ 결론**

이 문서에서는 Trivy를 활용하여 Maven 프로젝트와 OWASP Juice Shop Docker 이미지에서 보안 취약점을 탐지하고 분석하는 방법을 다루었습니다. Maven 프로젝트에서는 의도적으로 취약한 라이브러리를 포함하여 Trivy가 이를 탐지할 수 있음을 확인했으며, OWASP Juice Shop Docker 이미지에서는 JWT 토큰 및 RSA 개인 키와 같은 중요한 보안 취약점을 발견했습니다.

보안 취약점은 애플리케이션의 안정성과 신뢰성을 저해할 수 있는 요소로, 이를 사전에 탐지하고 대응하는 것이 중요합니다. **Trivy와 같은 도구를 사용하여 정기적으로 보안 점검을 수행하고, 발견된 취약점에 대해 적절한 조치를 취함으로써 애플리케이션의 전반적인 보안성을 강화**할 수 있습니다.

## **📚 참고 자료**
- [OWASP Juice Shop GitHub 리포지토리](https://github.com/juice-shop/juice-shop)
- [Trivy GitHub 리포지토리](https://github.com/aquasecurity/trivy)
