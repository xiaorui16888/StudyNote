# 使用pyinstaller打包，subprocess报“句柄无效”错误的解决方法

本文转自：https://my.oschina.net/u/2396236/blog/1610765

使用pyinstaller打包python程序，使用-w参数，去掉console，发现执行命令行的subprocess相关语句报“[ERROR] [WinError 6] 句柄无效”的错误。
去掉-w参数，将console显示的话，就正常。
我原本的语句是：

```python
#用 subprocess.check_output获取adb devices命令运行的输出
deviceInfo = subprocess.check_output('adb devices').decode().split("\r\n")
```

这里需要获得命令的运行输出，试了好多方案，最终可行的方案是用`subpross.Popen`来替代`subprocess.check_output`，Popen函数加入如下参数：`shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE
Popen`方法执行命令，父进程不会等待子进程。这个时候需要用`wait()`方法来等待运行的结果。
这里用自己写的`subprocess_check_output`来替代`subprocess.check_output `代码如下：

```python
def subprocess_check_output(*args):
    p = subprocess.Popen(*args,shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    msg = ''
    for line in p.stdout.readlines():
        msg += line.decode()
    status = p.wait()
    return msg

deviceInfo = subprocess_check_output('adb devices').split("\r\n")
```

这样就解决了这个问题。