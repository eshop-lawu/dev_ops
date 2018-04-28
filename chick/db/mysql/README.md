拉取镜像
======
```Bash
docker pull mysql:5.7.18
```


启动
======
#测试环境
```Bash
docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456 -d -p 3306:3306 \
    -v /usr/local/chick/mysql/data:/var/lib/mysql \
    -v /etc/localtime:/etc/localtime:ro \
    mysql:5.7.18
```