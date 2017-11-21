一、私有仓库服务器
====
1、配置hosts
----
192.168.100.94 registry.eshop.com

2、生成密钥文件
----
```bash
mkdir -p ~/certs
cd ~/certs
openssl genrsa -out registry.eshop.com.key 2048
```

3、生成证书
----
```bash
openssl req -newkey rsa:4096 -nodes -sha256 -keyout registry.eshop.com.key -x509 -days 365 -out registry.eshop.com.crt
```

4、拷贝证书
----
```bash
sudo mkdir -p /etc/docker/certs.d/registry.eshop.com
sudo cp ~/certs/registry.eshop.com.crt /etc/docker/certs.d/registry.eshop.com/
```

5、重启docker
----
```bash
sudo systemctl restart docker
```

6、启动私库
----
```bash
sudo docker run -d -p 443:5000 -p 80:5000 --restart=always --name registry \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/local/eshop/certs:/certs \
    -v /usr/local/eshop/docker/registry:/var/lib/registry \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.eshop.com.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.eshop.com.key \
    registry
```
```bash
sudo docker run -d -p 443:5000 --restart=always --name registry2 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /usr/local/eshop/certs:/certs \
    -v /usr/local/eshop/docker/registry:/var/lib/registry \
    -v /usr/local/eshop/docker/config.yml:/etc/docker/registry/config.yml \
    registry:2.3.0
```

7、垃圾回收
----
```bash
docker exec -it registry registry garbage-collect /etc/registry/config.yml
```

二、客户机
====
1、配置hosts
----
192.168.100.94 registry.eshop.com

2、拷贝证书
----
将私库的证书拷贝至/etc/docker/certs.d/registry.eshop.com/