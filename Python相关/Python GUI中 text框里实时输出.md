# Python GUI中 text框里实时输出

首先GUI中不同函数的局部变量的问题，我发现不同button定义的函数得到的变量无法通用。可以通过global 函数内的变量可以解决这个问题。

```python
def openfiles2():
    global s2fname
    s2fname = filedialog.askopenfilename(title='打开S2文件', filetypes=[('S2out', '*.out'), ('All Files', '*')])
    text.insert(tkinter.END, 'S2打开成功\n'+s2fname+'\n')
def openfilecgns():
    global cgnsfname
    cgnsfname = filedialog.askopenfilename(title='打开CGNS文件',filetypes=[('CGNSdat', '*.dat'), ('All Files', '*')] )
    text.insert(tkinter.END, 'CGNS dat 打开成功\n'+cgnsfname+'\n')
def show():
```

-Text文本框的定义和输出

定义：

```python
text=tkinter.Text(root,width=20,height=20)
text.pack(fill=tkinter.X,side=tkinter.BOTTOM  )
```

用到fill 可以填充某个方向，这次填充X方向，使得界面更好看。 side可以放置在不同的位置。但是这次用起来很多错误。

以后可以尝试不用import tkinter 可以用`from tkinter  import * `虽然更危险，但是网上大部分的代码都是这样导出的。更容易参考。

实时更新并查看：

```python
text.insert(tkinter.END, 'this Row finished...\n')  # INSERT表示在光标位置插入
text.see(tkinter.END)
text.update()
```

如果不update就是，等到计算函数计算完之后才可以得到新的insert的数据。

用update可以解决这个问题。

利用see(END)  解决文本框滚动的问题。自动显示最新的一行信息。类似于各种商业软件求解器。