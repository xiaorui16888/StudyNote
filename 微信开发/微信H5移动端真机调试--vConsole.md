# 微信H5移动端真机调试--vConsole

在移动端实际开发中，还是会碰到一些棘手的bug，想看看到底哪里出了问题，苦于移动端不能F12啊。友好的微信给我们提供了这么一个入口，使开发者可以真机调试。给微信开发者点赞。然后就可以看到你打印的内容及其他的信息，比如cookie、LocalStorage,Network、Element……

微信打开这个网址 http://debugx5.qq.com/ 暖心的我给你准备好了二维码，扫一扫吧（不要太感动……）

![image-20211225010234202](微信H5移动端真机调试--vConsole.assets/image-20211225010234202.png)

进去后，选择中间“信息”，然后一直往下翻，把vConsole打开，把下面两个Content Cache关掉。

然后打开你要调试的页面，你就你能看到右下角有个绿色按钮vConsole。点击就能查看你代码中console的内容了。

其实还有一种方法是引入vConsole文件。就直接可以看到打印的东西了。他们讲的很明白，我就不多说了。
https://github.com/Tencent/vConsole/blob/dev/doc/tutorial_CN.md
再次感谢腾讯...，是不是意犹未尽，但是已经结束了……