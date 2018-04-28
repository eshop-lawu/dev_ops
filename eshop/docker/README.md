安装docker
======

准备工作
------
关闭防火墙
```bash
sudo systemctl disable firewalld
```
如果安装之前没有关闭防火墙，需要关闭防火墙后再清掉防火墙配置，再重启docker
```bash
sudo iptables -F;sudo iptables -X
```

通过阿里云加速安装docker
------
参考地址： https://cr.console.aliyun.com/?spm=5176.100239.blogcont29941.12.MkthiN#/accelerator
更新软件源信息：https://yq.aliyun.com/articles/110806?spm=5176.8351553.0.0.18361991t01QNj

指定版本安装版本
```bash
sudo yum -y install docker-ce-17.06.0.ce-1.el7.centos
```

把当前用户加入到docker用户组
```bash
sudo usermod -aG docker dev2
```
or
```bash
sudo gpasswd -a dev2 docker
```


Docker的使用
======
使用docker构建基础服务和业务服务镜像，再推送到私库

构建Docker镜像
------
以构建redis镜像为例

拷贝项目中deploy下的redis目录到私库服务器的/usr/local/eshop/下
```Bash
cd /usr/local/eshop/redis/cluster
sudo docker build -t registry.eshop.com/redis:3.2.6-alpine .
```
or
```Bash
sudo docker build -t registry.eshop.com/redis:3.2.6-alpine /usr/local/eshop/redis/cluster
```

推送Docker镜像
------
```bash
sudo docker push registry.eshop.com/xxx:1.0
```

设置日志docker日志大小
------
```bash
vim /etc/docker/daemon.json

{
  "log-opts": {
    "max-size": "1g"
  }
}
```