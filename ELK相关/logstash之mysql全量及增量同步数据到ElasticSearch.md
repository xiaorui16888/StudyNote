# logstash之mysql全量及增量同步数据到ElasticSearch

## 前言

我一般数据都是存在mysql的，但是mysql的全文检索性能，大家也都知道。数据量小还没啥事，一旦数据量上了几百万，几千万，分分钟给你卡死...

所以我都是把需要检索用到的数据，同步到es中。但是怎么同步呢？我之前提到过`logstash`。有人说，把mysql中的数据导出成csv同步到es，或者就excel直接扔到es中。这种方法我也去实践了一遍，结果经常有一些数据中含有特殊的一些字符，同步失败，而导致很多数据都没有成功同步上去。

那算了，这种方法我们就弃用了！

`logstash`其实给我们提供了，mysql数据同步到es中。无需我们初始化一个demo，写一大堆代码，同步到es中。

说干就干！

## 准备工作

es与logstash的版本保持一致，

下载jdbc-connector的jar包，`mysql-connector-java.jar`

*maven仓库下载*：https://mvnrepository.com/artifact/mysql/mysql-connector-java

下载完成后，解压到logstash/lib/jars/中。

### 配置导入脚本

新建配置目录：sync-config，新建`jdbc.conf`

```yml
input {
    stdin {}
    jdbc {
   		# mysql 数据库链接
        jdbc_connection_string => "jdbc:mysql://127.0.0.1:3306/cicada?characterEncoding=utf8"
        # 用户名和密码
        jdbc_user => "root"
        jdbc_password => "root123"
        # 驱动
        jdbc_driver_library => "./lib/jars/mysql-connector-java-5.1.13.jar"
        # 驱动类名
        jdbc_driver_class => "com.mysql.jdbc.Driver"
        jdbc_paging_enabled => "true"
        jdbc_page_size => "50000"
        # 时区
        jdbc_default_timezone => "Asia/Shanghai"
        # 执行的sql文件路径和名称
        statement_filepath => "./sync-config/user_sql.sql"
        #直接执行sql语句
      	# statement =>"select * from employee"
        # 设置监听间隔，各字段含义（由左至右）分、时、天、月、年，全部为*默认含义为每分钟都更新
        schedule => "* * * * *"
        # 索引类型
        type => "User"
        lowercase_column_names => false
        # 是否记录最后一次运行内容
        record_last_run => true
        # 是否适用列元素
        use_column_value => true
        # 追踪的元素名，对应保存到es上面的字段名而不是数据库字段名
        tracking_column => "updateTime"
        # 默认为number，如果为日期必须声明为timestamp
        tracking_column_type => "timestamp"
        # 设置记录的路径
        last_run_metadata_path => "./sync-config/user_last_time"
        clean_run => false
    }
    jdbc {
        jdbc_connection_string => "jdbc:mysql://127.0.0.1:3306/cicada?characterEncoding=utf8"
        jdbc_user => "root"
        jdbc_password => "root123"
        jdbc_driver_library => "./lib/jars/mysql-connector-java-5.1.13.jar"
        jdbc_driver_class => "com.mysql.jdbc.Driver"
        jdbc_paging_enabled => "true"
        jdbc_page_size => "50000"
        jdbc_default_timezone => "Asia/Shanghai"
        statement_filepath => "./sync-config/log_sql.sql"
        schedule => "* * * * *"
        type => "Log"
        lowercase_column_names => false
        record_last_run => true
        use_column_value => true
        tracking_column => "updateTime"
        tracking_column_type => "timestamp"
        last_run_metadata_path => "./sync-config/log_last_time"
        clean_run => false
    }
}
filter {
    json {
        source => "message"
        remove_field => ["message"]
    }
}
output {
    if [type] == "User" {
        elasticsearch {
            hosts => ["127.0.0.1:9200"]
            # 索引名称
            index => "cicada_user_search"
            # type名称
            document_type => "user_search_index"
             # 文档id，inquiryId为sql文件中查询出的字段名
            document_id => "%{id}"
        }
    }
    if [type] == "Log" {
        elasticsearch {
            hosts => ["127.0.0.1:9200"]
            index => "cicada_log_search"
            document_type => "log_search_index"
        }
    }
}
```

### SQL文件

- user_sql.sql

  ```sql
  SELECT
  	id,
  	user_name userName,
  	user_phone userPhone,
  	create_time createTime,
  	update_time updateTime
  FROM c_user
  WHERE update_time > :sql_last_value
  ```

- log_sql.sql

  ```mysql
  SELECT
  	id,
  	param_value paramValue,
  	request_ip requestIp,
  	create_time createTime,
  	update_time updateTime
  FROM c_log
  WHERE update_time > :sql_last_value
  ```

### 配置参数说明

- input参数

  ```yml
  statement_filepath：读取SQL语句位置
  schedule ：这里配置每分钟执行一次
  type ：类型，写入ES的标识
  lowercase_column_names ：字段是否转小写
  record_last_run ：记录上次执行时间
  use_column_value ：使用列的值
  tracking_column ：根据写入ES的updateTime字段区分增量数据
  tracking_column_type ：区分的字段类型
  ```

- output参数

  ```yml
  hosts ：ES服务地址
  index ：Index名称，类比理解数据库名称
  document_type ：Type名称，类比理解表名称
  ```

### 启动导入脚本

```shell
logstash -f "./sync-config/jdbc.conf"
```



## 其他

### logstash7.x同步mysql数据到es报错

logstash能正常启动但是同步数据到es时报错

```
com.mysql.jdbc.Driver not loaded. Are you sure you’ve included the correct jdbc driver in :jdbc_driver_library?
Unable to find driver class via URLClassLoader in given driver jars: com.mysql.jdbc.Driver and com.mysql.jdbc.Driver
```

**解决办法**：将mysql的驱动jar包拷贝到logstash目录\logstash-core\lib\jars 下

如果这种办法没有解决你的问题，你可以看看这篇帖子，我没试过，因为上面这种方法解决了我的问题。

https://www.jianshu.com/p/0e893f29ee05

*LogStash 7.x com.mysql.cj.jdbc.Driver not loaded*

### MYSQL资源下载

https://downloads.mysql.com/archives/

### Logstash 配置定时

```yml
# 设置监听时段 个字段含义(从左到右)，分,时,天,月,年, 
# 全部默认为*号默认为每分钟更新
#每分钟执行一次
schedule => "* * * * * "
# 每间隔一分钟执行一次
schedule => "*/1 * * * *"
#每小时执行一次
schedule =>"* */1 * * *"
#某个时间点执行
schedule =>"* 1 * * *"    # 每天上午1点执行
#多个时间点执行
schedule =>"* 1,3,5 * * *"    # 每天上午1,3,5点执行
```

### es-mysql-logstash 软删除的实现

如果一个文档从 MySQL 中删除，该操作并不会同步到 ElasticSearch 中。列举几个我们可以考虑的方案。

MySQL 中的记录可通过包含 is_deleted 字段以表明该条记录是否有效。一旦发生更新，is_deleted 也会同步更新到 ElasticSearch 中。如果通过这种方式，在执行 MySQL 或 ElasticSearch 查询时，重写查询语句来过滤掉 is_deleted 为 true 的记录。同时，可以通过一些后台进程将 MySQL 和 ElasticSearch 中的这些文档删除。

另一个可选方案是，应用系统负责 MySQL 和 ElasticSearch 中数据的删除，即应用系统在删除 MySQL 中数据，同时负责也删除 ElasticSearch 中相应的文档。这个就会到程序层面的开发工作。

再谈一种方案，脱离 logstash 来谈这个问题。

可以通过 mysql 的 binlog 实现数据库中的得事件(增加、更新、删除)同步，任何事件实时同步到 Elasticsearch。这个相对较复杂了。但好在已经有了开源组件可以用，即阿里的 canal。不过，我个人认为，项目不大，且实时性要求不高，还是用 logstash 比较简单省心。canal 在单表时，还比较简单，如果涉及多表，也不方便，根据需求会有不定量的的开发工作。

最后，要依据场景选择合适的方案。把它们进行适时地结合，实时性要求高，用 canal 实现，一般场景，logstash 即可，即使是有题主提的删除，也不建议使用 canal，而是用前面提到的几个思路。有能力的话，其实可以针对这两种方案设计一个数据同步框架，以后只要加个配置即可完成。

**这里的方案，是我在网上看到的，最近不着急实现这个功能，有空了再实现一下。**

### 联表的sql文件

```mysql
SELECT `a`.`id`,`a`.`catid`,`a`.`catids`,`a`.`title`,`f`.`name`, `a`.`status`,a.updated_at FROM `c_product` `a` LEFT JOIN `c_company` `f` ON f.id = a.cid WHERE a.updated_at > :sql_last_value order by a.updated_at
```

