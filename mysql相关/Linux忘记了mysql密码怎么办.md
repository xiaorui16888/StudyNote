# Linux忘记了mysql密码怎么办

本文都以 root 用户为例

首先需要拿到操作系统的root权限，然后kill掉mysql服务或者stop掉mysql服务。

这里我使用的是`stop`

```shell
systemctl stop mysqld
```

然后执行

```shell
mysqld_safe --skip-grant-tables &
```

&，表示在后台运行，不再后台运行的话，就再打开一个终端吧。

接着登录mysql修改密码

```mysql
mysql
use mysql;
UPDATE user SET password=password("test123") WHERE user='root';   
exit;
```

注意：如果Mysql的版本是5.7及以上的话update语句如下：

```mysql
update user set authentication_string=passworD("test") where user='root';
```

然后执行 

```mysql
FLUSH PRIVILEGES;
```

**修改完密码记得重启mysql哦。**

---

**这里有个坑~**

如果使用

```mysql
UPDATE user SET password=password("test123") WHERE user='root';   
```

终端返回，大致意思如下

在--skip-grant-tables 模式下，无法执行该条sql语句

那我们可以通过修改mysql配置文件`my.cnf`的方式，拿到mysql权限

如果你不知道mysql配置文件的路径，那你可以使用

```shell
whereis my.conf
```

拿到路径

![image-20211224232232754](Linux忘记了mysql密码怎么办.assets/image-20211224232232754.png)

然后在`[mysqld]`段下加入一行

```
skip-grant-tables
```

执行上面修改密码的操作，修改完毕后，记得删掉刚才在配置文件中加入的那一行。

然后重启mysql服务

```shell
systemctl restart mysqld
```

以上就是在linux系统中忘记了mysql密码的解决方案。

那如果你没忘记mysql密码，仅仅是想修改它的密码。那就是有update命令修改mysql-root用户的密码就可以了。