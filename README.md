# 프로젝트 생성 WorkFlow

## create project folders

```sh
# create folders / files
cd /volume1/docker/platforms/ilmac-ubuntu-dev/projects
./cp.sh <PROJECT_NAME>
```

## 환경 변수 등록

### BACKEND
> `/volume1/docker/platforms/ilmac-ubuntu-dev/.env`

> syntax

```ini
## BACKEND PORT
### [PROJECT_NAME]
BE_PORT_<PROJECT_NAME>_<MODULE1>=
BE_PORT_<PROJECT_NAME>_<MODULE2>=

##  FRONTEND PORT
### [PROJECT_NAME]
FE_PORT_<PROJECT_NAME>_NEXTJS=
```

> 예시: .env
```ini
#------------------------------------------------------------------------------
# PORT
## SERVER
SV_PORT_SSH=11001
ROOT_PASSWORD=password

## BACKEND PORT
### [bid-notice-web]
BE_PORT_BID_NOTICE_SPIDER=11301
BE_PORT_BID_NOTICE_MYSQL=11302
BE_PORT_BID_NOTICE_BID=11303
BE_PORT_BID_NOTICE_BOARD=11307

##  FRONTEND PORT
### [bid-notice-web]
FE_PORT_BID_NOTICE_NEXTJS=11501
```

> `/volume1/docker/platforms/ilmac-ubuntu-dev/projects/<PROJECT_NAME>/frontend/.env.local`
- .env에서 불러올 수 없으므로 수동으로 설정(변수 사용안됨)

> 예시: `.env.local`
```ini
NEXT_PUBLIC_APP_URL=http://localhost:11501

## API
### GRAPHQL
NEXT_PUBLIC_GRAPHQL_URL=http://localhost:11501/api/graphql
### REST
NEXT_PUBLIC_REST_API_URL=http://localhost:11501/api/rest

## BACKEND
NEXT_PUBLIC_BACKEND_IP=localhost
NEXT_PUBLIC_BACKEND_BID_URL=http://localhost:11303
```

> `/volume1/docker/platforms/ilmac-ubuntu-dev/projects/<PROJECT_NAME>/frontend/package.json`
- .env에서 불러올 수 없으므로 수동으로 설정(변수 사용안됨)

> 예시: `.env.local`

```json
  "scripts": {
    "dev": "next dev -p 11501",
    "start": "next start -p 11501",
    "build": "next build",
    "scrape:test": "tsx src/lib/scraper/test/gangnam.ts"
  },
```