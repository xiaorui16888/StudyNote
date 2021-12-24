# Centos7安装及使用webbench进行并发测试

只是做一些简单的本机并发测试，PHP执行效率还有待更多测试。

一.安装webbench

1.如果没有安装GCC就先执行

```shell
yum -y install gcc automake autoconf libtool make
```

2.安装ctags及创建一个文件夹

```shell
yum install ctags
mkdir -m 644 -p /usr/local/man/man1
```

3.获取及安装webbench

```shell
wget http://blog.zyan.cc/soft/linux/webbench/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make && make install
```

二.使用webbench

并发限制101，持续时间60秒

```shell
webbench -c 101 -t 60 http://www.yourwebsite.com/
```

这样就ok了。