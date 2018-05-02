构建镜像
======
alpine中缺少FontConfiguration解决方案

拷贝项目中deploy下的docker/baseimage到/usr/local/eshop/baseimage2
这个镜像是所有业务系统的基础镜像
```Bash
sudo docker build -t registry.eshop.com/java:8-alpine-2 .
```

参考资料
------
https://www.jianshu.com/p/e39ee0cad05b