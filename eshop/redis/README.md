拉取镜像
======
```Bash
docker pull redis:3.2.6-alpine
```


启动
======
```Bash
docker run --name redis -p 6379:6379 -d redis:3.2.6-alpine
```

清空数据
=====

连接到redis
-----
```bash
sudo docker exec -it redis1 /bin/sh
redis-cli -c -h 192.168.100.90 -p 7000
```
删除某个前缀的key
-----
单节点
```bash
redis-cli -c -p 7000 DEL $(redis-cli -c -p 7000 KEYS "AD_KEY_MEMBER_ID_*" | sed -r "s/\".*\"/$/g")
```


集群环境不能批量删除
```bash
for id in `redis-cli -c -p 7000 KEYS "AD_KEY_MEMBER_ID_*" | sed -r "s/\".*\"/$/g"`
do
echo $id
redis-cli -c -p 7000 DEL $id
done
```

删除当前数据库中的所有Key
-----
```Bash
flushdb
```

删除所有数据库中的key
------
```Bash
flushall
```