# 🌍 Terraform을 사용한 AWS S3 정적 파일 호스팅 및 IaC 실습

**AWS S3**를 정적 파일 호스팅 용도로 사용하고, **Terraform**을 활용해 Infrastructure as Code(IaC) 방식으로 S3 버킷과 관련 리소스를 관리하는 실습입니다. 단계별로 Terraform 설정 파일을 통해 S3 버킷 생성, 파일 업로드 및 수정을 자동화하는 과정을 다룹니다.

## 🌱 Terraform이란?

**Terraform**은 인프라를 코드로 관리(Infrastructure as Code)할 수 있게 해주는 오픈소스 도구입니다. 다양한 클라우드 제공업체(AWS, Azure, GCP 등)와 호환되며, 인프라의 프로비저닝, 관리, 버전 제어를 자동화할 수 있습니다. 이를 통해 인프라를 선언적으로 정의하고, 재사용 가능하며 일관된 환경을 손쉽게 구축할 수 있습니다.

## AWS CLI 설정

```bash
aws configure
```

위 명령어를 통해 AWS Access Key, Secret Access Key, 리전 등을 설정합니다.

## Terraform 설치 및 초기 설정

```bash
$ sudo su -
# wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
# apt-get update && apt-get install terraform -y
# terraform -version
```

## 📁 파일 구조

```
.
├── iam_policy.tf             # IAM 역할 생성, 정책 정의, 역할 연결
├── create_bucket.tf          # 🪣 S3 버킷 생성
├── upload_new_index.tf       # 새로운 index.html 파일 업로드
├── upload_modified_index.tf  # 다른 버전의 index.html 업로드
├── index.html                # 기본 index.html 파일
├── main.html                 # 추가로 업로드할 main.html 파일

```

## IAM 유저에 S3 사용 권한 부여

S3 버킷을 생성할 수 있는 IAM 역할을 만듭니다.<br>
S3에 대한 모든 권한을 부여하는 정책(`s3-full-access-policy`)을 정의하고 IAM 역할에 연결합니다.

## 1. S3 버킷 생성

- **목적**: AWS S3 버킷을 생성합니다.
- **사용 방법**:
  ```bash
  terraform init
  terraform apply -target=aws_s3_bucket.bucket1
  ```

## 2. 새로운 `index.html` 파일 업로드

생성된 S3 버킷에 새로운 `index.html` 파일을 업로드합니다.

- **사용 방법**:
  ```bash
  terraform apply -target=aws_s3_object.index_html
  ```

## 3. 다른 버전의 `index.html` 파일 업로드

기존의 `index.html` 파일을 업데이트합니다.

- **사용 방법**:
  ```bash
  terraform apply -target=aws_s3_object.index_html_v2
  ```

## 4. `main.html` 파일 업로드

S3 버킷에 `main.html` 파일을 추가로 업로드합니다.

- **사용 방법**:
  ```bash
  terraform apply -target=aws_s3_object.main
  ```

## 📝 사용법 정리

1. **Terraform 초기화**:
   Terraform은 프로젝트 디렉토리를 처음 설정하거나, 프로바이더나 모듈이 추가되거나 업데이트될 때 다시 초기화를 수행합니다.

   ```bash
   terraform init
   ```

2. **계획 확인**:
   Terraform이 실행할 변경 사항을 예측하고 보여줍니다.
   ```bash
   terraform plan
   ```
3. **리소스 적용**
   실제로 리소스를 생성하거나 수정합니다.

   ```bash
   terraform apply
   ```

   terraform plan에서 보여주었던 변경 사항을 실행하고, 리소스를 프로비저닝합니다. <br> `-auto-approve` 옵션을 추가하면 변경 사항에 대해 수동으로 승인할 필요 없이 자동으로 적용됩니다.
   <br>

   💡 `terraform apply` 명령어는 현재 프로젝트 디렉토리 내의 모든 .tf 파일을 사용하여 정의된 리소스를 전체적으로 적용합니다. <br>
   특정 리소스만 선택적으로 적용하려면 `terraform apply -target=<resource>` 옵션을 사용합니다.

## 리소스의 범위와 예시

리소스의 범위는 각 클라우드 서비스가 제공하는 구성 요소 단위입니다. Terraform에서는 리소스를 다음과 같이 정의합니다. <br>

```hcl
resource "<provider>_<resource_type>" "<name>" {
    # 리소스 속성 설정
}
```

예시로, S3 버킷을 생성하는 리소스는 다음과 같이 정의할 수 있습니다.

```hcl
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-bucket-name"
}
```

`aws_s3_bucket`: AWS S3 버킷 리소스를 의미합니다. <br>
`bucket1`: 해당 리소스의 이름입니다. <br>
`속성들`: S3 버킷의 이름, 버전 관리 여부, 접근 제어 등을 설정할 수 있습니다. <br>

## 리소스 간 상호작용 및 주의사항

리소스들은 서로 의존성을 가질 수 있습니다. 예를 들어, S3 버킷을 생성한 뒤 해당 버킷에 파일을 업로드하려면, 버킷이 먼저 생성되어 있어야 합니다. <br>
**Terraform은 각 리소스 간의 의존성을 자동으로 감지하고 순서를 조정**하지만, 명시적으로 `depends_on` 속성을 사용하여 순서를 지정할 수도 있습니다.

```hcl
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-bucket"
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.bucket1.id
  key    = "index.html"
  source = "index.html"
}
```

위 예시에서 aws_s3_object는 aws_s3_bucket 리소스에 의존하고 있으며, 버킷이 생성되기 전에 파일을 업로드할 수 없습니다.

Terraform을 사용할 때는 리소스 간의 상호작용을 고려하여 의존성을 명확하게 정의하고 관리하는 것이 중요합니다.
