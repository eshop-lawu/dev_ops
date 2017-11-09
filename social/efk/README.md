日志统一管理
====
    Elastic Search + Fluentd + Kibana

构建fluentd镜像（集成elasticsearch插件）
----
```Bash
docker build -t registry.eshop.com/fluentd:v0.12-debian .
```

Elastic Search
----
    http://localhost:9200/
    elastic/changeme

Kibana
----
    http://localhost:5601/
    elastic/changeme
    
    正式环境用户名密码：elastic/eshop@1qazXSW@
    
    登录后，在Index Pattern中将"Index name or pattern"配置为"fluentd-*"，"Time-field name"配置为"@timestamp"。详见参考资料[1]

参考资料
----
[1]https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose
[2]https://docs.docker.com/engine/admin/logging/fluentd/