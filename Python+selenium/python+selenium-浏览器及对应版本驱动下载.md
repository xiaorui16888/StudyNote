# python+selenium-浏览器及对应版本驱动下载

## 安装selenium模块

```shell
pip3 install selenium
```

自动化运行需要在对应的浏览器安装对应的驱动

## Driver下载

　　浏览器下载安装完成之后如果想要用代码调用起该浏览器，就需要下载对应的驱动文件，下面我给几个驱动文件的下载地址：

　　Firefoxdriver下载地址：

```
https://github.com/mozilla/geckodriver/releases
```

　　IEdriver下载地址：

```
http://selenium-release.storage.googleapis.com/index.html
```

　　Chromedriver下载地址：

```
http://chromedriver.storage.googleapis.com/index.html
```

### 安装驱动

把下载的驱动包解压后，放到项目下也可以。但是最好放在python的安装目录下。否则如果你新建一个类包，程序就无法读取到驱动包的路径。

保险起见，再放一份驱动包到浏览器的安装根目录下，就ok了。