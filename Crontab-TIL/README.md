# 🤔 TIL 자동화 프로젝트

이 프로젝트는 매일 자동으로 TIL(Today I Learned) 디렉토리를 생성하고 관리하는 작업을 자동화합니다. 이 스크립트는 매일 아침 9시에 새로운 디렉토리와 파일을 생성하며, 같은 날 저녁 10시에 디렉토리를 백업합니다.

## 프로젝트 구조

- `create_daily_files.sh`: 매일 아침 9시에 현재 날짜로 디렉토리를 생성하고, `fisa1`부터 `fisa5`까지의 파일을 해당 디렉토리에 생성하는 스크립트입니다.
- `backup_daily_files.sh`: 매일 저녁 10시에 해당 날짜의 디렉토리를 압축하여 백업하는 스크립트입니다.
- `crontab`과의 연동: 이 스크립트를 `crontab`과 함께 사용할 때, `crontab`이 설정된 시간에 따라 자동으로 이 스크립트가 실행됩니다.

### 1. 디렉토리 및 파일 생성 스크립트 (`create_daily_files.sh`)

```bash
#!/bin/bash

# 오늘의 날짜를 YYYY-MM-DD 형식으로 저장
DATE=$(date +%Y-%m-%d)

# 파일을 저장할 위치 설정
BASE_DIR=~/TIL/$DATE

# 디렉토리가 이미 존재하지 않는 경우 생성
if [ ! -d "$BASE_DIR" ]; then
  mkdir -p "$BASE_DIR"
fi

# fisa1~fisa5 파일 생성
for i in {1..5}; do
  touch "$BASE_DIR/fisa$i"
done

echo "Directories fisa1~fisa5 have been created in $BASE_DIR"
```

이 스크립트는 다음과 같은 작업을 수행합니다:

- 오늘 날짜(YYYY-MM-DD)를 기준으로 TIL 디렉토리 생성
- `fisa1~fisa5` 파일 생성

### 2. 백업 스크립트 (`backup_daily_files.sh`)

```bash
#!/bin/bash

# 오늘의 날짜를 YYYY-MM-DD 형식으로 저장
DATE=$(date +%Y-%m-%d)

# 백업할 위치 설정
BASE_DIR=~/TIL/$DATE
BACKUP_FILE=~/TIL/${DATE}_backup.tar.gz

# 디렉토리를 압축하여 백업
tar -czf "$BACKUP_FILE" -C ~/TIL "$DATE"

echo "Backup completed: $BACKUP_FILE"
```

이 스크립트는 다음과 같은 작업을 수행합니다:

- 현재 날짜 디렉토리를 압축하여 백업

### 3. Crontab 설정

이 스크립트들을 매일 자동으로 실행하기 위해 `crontab`을 설정합니다.
Crontab 설정 방법:

```bash
crontab -e
```

**디렉토리 및 파일 생성 (아침 9시)**:

```bash
0 9 * * * /bin/bash /path/to/your/create_daily_files.sh
```

**디렉토리 압축 및 백업 (저녁 10시)**:

```bash
0 22 * * * /bin/bash /path/to/your/backup_daily_files.sh
```

### 폴더 구조 예시

```text
~/TIL/
├── 2024-09-25/
│   ├── fisa1
│   ├── fisa2
│   ├── fisa3
│   ├── fisa4
│   └── fisa5
└── 2024-09-25_backup.tar.gz
```

## 정리

`crontab`은 지정된 시간에 스크립트를 자동으로 실행하도록 예약합니다. 아침 9시에 실행된 스크립트는 새 날짜 디렉토리를 만들고 필요한 파일을 생성합니다. 저녁 10시에 실행된 스크립트는 해당 디렉토리를 압축하여 백업 파일을 생성합니다. 이를 통해 TIL 레포지토리 관리를 자동화할 수 있습니다.
