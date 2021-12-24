# 最稳的上网方式：v2ray+ws+tls一键脚本（CentOS7版）

## 方案说明

> * 1、一键脚本需要VPS安装为CentOS7系统。
> *  2、本方案需要一个域名并解析到你的VPS的IP，随便买个一刀以内的便宜域名，freenom可能不好申请免费的域名了。
> * 3、编译安装支持TLS1.3的nginx，安装过程稍慢，耐心等待。
> * 4、当前版本v2ray不支持TLS1.3，当v2ray支持后，本次一键搭建的服务端可升级支持
> * 5、搭配bbr加速，可以让速度有较大的提升
> * 6、一键脚本会为你配置一个英文模板的网站，你也可以自行替换自己的网页。

## 一键脚本搭建服务端

**注意：务必保证域名解析已经成功了，再使用下面的脚本安装。**

**打开电脑命令行，ping 你的域名，如果显示VPS的IP地址，则解析生效了。**

1、使用SSH工具连接VPS，执行下列命令，选择安装v2ray+ws+tls

```shell
wget -N --no-check-certificate -q -O install.sh "https://raw.githubusercontent.com/wulabing/V2Ray_ws-tls_bash_onekey/master/install.sh" && chmod +x install.sh && bash install.sh
```

2、等待脚本执行，过程中会提示需要输入域名，输入解析到本VPS的域名，然后回车

3、等待安装完成，你可以看到配置参数，客户端配置时用到。

4、安装BBR加速，指向下面命令

```shell
cd /usr/src && wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh" && chmod +x tcp.sh && ./tcp.sh
```

5、注意在弹出的安装界面首先选择1，安装BBR内核,安装过程可能时间较长,耐心等待。

6、安装完成后会提示重启VPS,输入Y，然后回车，确认重启。然后等待几分钟，再使用xshell连接vps（连接方法是点软件上打开，找到之前保存的连接，然后点连接）登陆后执行下列命令

```shell
cd /usr/src && ./tcp.sh
```

7、在弹出安装界面,输入5,然后回车，使用BBR魔改版加速，等待安装完成提示bbr启动成功即可。

基本阿里云的机器可以输入6，基本可以把网速拉满，很丝滑~~~

## 客户端配置

1、下载v2ray客户端

v2ray各平台客户端：https://www.v2ray.com/awesome/tools.html

2、将参数对应填写到客户端

这里大概说明一下参数怎么填写：

地址：你的域名，例如google.com

端口：443

用户ID：就是一长串uuid

加密方式：aes-128-gcm

传输协议：ws

path：就填路径这个参数

底层传输：tls

3、开启上网即可

## 伪装网站配置

脚本已经为你创建了一个英文模板站，如果你想自己为VPS配置一个其他的伪装站点，可自行获取网页文件，入口页包含**index.html**，将其传输到VPS的**/etc/nginx/html**目录下，重启VPS即可。

如果用了几天后，你觉得网速有明显的下降，使用这条命令:

```shell
systemctl restart NetworkManager
```

