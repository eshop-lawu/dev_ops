启用时指定项目名称
======
```bash
SUFFIX=1 TAG=latest docker-compose -f docker-compose-api.yml -p api1 up -d
```
```bash
SUFFIX=1 TAG=latest docker-compose -f docker-compose-srv.yml -p srv1 up -d
```