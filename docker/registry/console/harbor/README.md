1.准备
-----
拷贝docker\registry\console\harbor到/usr/local/eshop/harbor
修改harbor.cfg的配置

2.安装
-----
```bash
./install
```

3.重启
-----
```bash
docker-compose restart
```

4.刷新配置
-----
```bash
./prepare
```

5.更新升级
-----
```bash
./upgrade
```