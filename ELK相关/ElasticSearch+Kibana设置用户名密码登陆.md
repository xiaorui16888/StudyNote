# ElasticSearch+Kibana设置用户名密码登陆

## 配置

修改es的配置文件：elasticsearch.yml，添加如下配置

```yml
xpack.security.enabled: true
xpack.license.self_generated.type: basic
xpack.security.transport.ssl.enabled: true
```

es的bin目录下，执行设置用户名和密码的命令

```shell
./elasticsearch-setup-passwords interactive
```

这里会设置六个账号的密码：`elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user.`

修改kibana的配置`kibana.yml`：

```yml
elasticsearch.username: "elastic"
elasticsearch.password: "bj778899."
```

es修改密码的命令如下：

```shell
curl -H "Content-Type:application/json" -XPOST -u elastic 'http://localhost:9200/_xpack/security/user/elastic/_password' -d '{ "password" : "123456" }'
```

重启es和kibana

访问http://localhost:9200，需要输入账号密码才可以访问

## 集成ThinkPHP

```php
public function _initialize()
    {
        $hosts = ['http://localhost:8833'];
        $this->client = ClientBuilder::create()->setBasicAuthentication('elastic', 'bj778899.')->setHosts($hosts)->build();
    }
```

