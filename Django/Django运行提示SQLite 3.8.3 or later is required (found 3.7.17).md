#  Django运行提示:SQLite 3.8.3 or later is required (found 3.7.17)

CentOS运行Django时提示出错:SQLite 3.8.3 or later is required (found 3.7.17)，出现这种错误主要是因为SQLite版本太低的原因。我们升级一下SQLite的版本就好。 升级步骤如下: 去SQLite官网： https://www.sqlite.org/download.html 找到最新版本的tar.gz包下载下来。 如：

```shell
#下载
wget https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
# 编译
tar zxvf sqlite-autoconf-3310100.tar.gz

cd sqlite-autoconf-3310100

./configure --prefix=/usr/local

make && make install
# 替换系统低版本 sqlite3
mv /usr/bin/sqlite3  /usr/bin/sqlite3_old

ln -s /usr/local/bin/sqlite3   /usr/bin/sqlite3

echo "/usr/local/lib" > /etc/ld.so.conf.d/sqlite3.conf

ldconfig

sqlite3 -version
```

升级成功之后，就能正常运行！

```shell
python3 manage.py runserver
```

