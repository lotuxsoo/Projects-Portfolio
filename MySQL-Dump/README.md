# 🐳 MySQL 데이터베이스 이관 작업 with Docker

이 문서는 Docker를 사용하여 MySQL 데이터베이스의 스키마와 데이터를 덤프(dump)하고, 이를 새로운 MySQL 데이터베이스로 이관하는 방법을 설명합니다. 또한, 이 작업을 자동화하기 위한 크론탭 설정과 데이터 지속성을 위한 Docker 볼륨 사용 방법도 포함되어 있습니다.

## 사전 준비

- Docker가 설치된 환경
- 마이그레이션할 MySQL 컨테이너 (`mysqldb`) 실행 중
- Docker 및 MySQL 기본 명령어에 대한 이해

## 1단계: 기존 MySQL 데이터베이스 덤프

### 1.1 데이터베이스 스키마 덤프

데이터베이스의 스키마만 덤프하려면:

```bash
docker exec -it mysqldb mysqldump -u root -p --no-data your_database_name > schema.sql
```

- `mysqldb`: 기존 MySQL Docker 컨테이너 이름.
- `your_database_name`: 덤프할 데이터베이스의 이름.
- `--no-data`: 데이터 없이 스키마만 덤프.

### 1.2 데이터베이스 전체(스키마 + 데이터) 덤프

스키마와 데이터를 함께 덤프하려면:

```bash
docker exec -it mysqldb mysqldump -u root -p your_database_name > backup.sql
```

- `backup.sql` 파일에 데이터베이스의 스키마와 데이터가 함께 저장됩니다.

## 2. 새로운 MySQL Docker 컨테이너 생성

### 2.1 `newmysqldb` 컨테이너 생성

새로운 MySQL 컨테이너를 생성하려면:

```bash
docker run --name newmysqldb -e MYSQL_ROOT_PASSWORD=newpassword -d mysql:latest
```

- `newmysqldb`: 새 컨테이너 이름.
- `MYSQL_ROOT_PASSWORD`: 새 MySQL 컨테이너의 root 비밀번호.
- `mysql:latest`: 최신 MySQL 이미지를 사용.

## 3. 덤프 파일을 새로운 DB에 반영

#### 3.1 컨테이너에서 MySQL 접속

```bash
docker exec -it newmysqldb mysql -u root -p
```

#### 3.2 새로운 데이터베이스 생성

```sql
CREATE DATABASE new_database_name;
EXIT;
```

- `new_database_name`: 새로 생성할 데이터베이스 이름.

#### 3.3 덤프 파일 적용

새로 생성한 데이터베이스에 덤프한 데이터를 반영:

```bash
docker exec -i newmysqldb mysql -u root -p new_database_name < backup.sql
```

또는 스키마만 반영:

```bash
docker exec -i newmysqldb mysql -u root -p new_database_name < schema.sql
```

## 4. 크론탭을 이용한 자동화 (옵션)

정기적으로 데이터베이스 덤프 작업을 자동화하려면 크론탭을 설정할 수 있습니다.

```bash
crontab -e
```

매일 자정에 덤프 작업을 수행하도록 설정하려면 다음을 추가합니다.

```bash
0 0 * * * docker exec -it mysqldb mysqldump -u root -p your_database_name > /path/to/backup/backup_$(date +\%F).sql
```

## 5. Docker Volumes을 사용한 데이터 지속성 관리 (옵션)

데이터 지속성을 보장하기 위해 Docker 볼륨을 사용할 수 있습니다. 컨테이너 생성 시 볼륨을 마운트하여 호스트의 디렉토리를 컨테이너와 공유합니다.

```bash
docker run --name newmysqldb -v /path/on/host:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=newpassword -d mysql:latest
```

- `/path/on/host`: 호스트의 디렉토리 경로.
- `/var/lib/mysql`: MySQL 데이터베이스의 기본 데이터 디렉토리.

이 작업을 통해 데이터베이스 파일이 호스트 시스템에 저장되므로, 컨테이너가 삭제되어도 데이터는 유지됩니다.

## 결론

이 가이드를 따라 MySQL 데이터베이스를 새로운 Docker 컨테이너로 성공적으로 이관할 수 있습니다. 또한, 크론탭을 사용하여 이 작업을 자동화하거나, Docker 볼륨을 사용하여 데이터 지속성을 관리할 수 있습니다.
