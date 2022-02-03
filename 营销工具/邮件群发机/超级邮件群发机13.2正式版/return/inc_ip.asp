<%
'=========================================================
' QQWry.DAT 利用程序 修改自互联网流传代码
' 本类在ASP环境中使用纯真版QQWry.dat通过完美测试
' 如果您的服务器环境不支持ADodb.Stream，将无法使用此程序
' 推荐使用纯真数据库，更新也方便
' ========================================================

' ============================================
' 返回IP信息
' ============================================
Function Look_Ip(IP)
 Dim Wry, IPType, QQWryVersion, IpCounter
 ' 设置类对象
 Set Wry = New TQQWry
 ' 开始搜索，并返回搜索结果
 ' 您可以根据 QQWry(IP) 返回值来判断该IP地址在数据库中是否存在，如果不存在可以执行其他的一些操作
 ' 比如您自建一个数据库作为追捕等，这里我就不详细说明了
 IPType = Wry.QQWry(IP)
 ' Country：国家地区字段
 ' LocalStr：省市及其他信息字段
 Look_Ip = Wry.Country & " " & Wry.LocalStr
End Function
' ============================================
' 返回IP信息 JS调用
' ============================================
Function GetIpInfoAv(IP, sType)
 Dim Wry, IPType
 Set Wry = New TQQWry
 IPType = Wry.QQWry(IP)
 
 Select Case sType
  Case 1 GetIpInfoAv = "document.write(""" & IP & """);"
  Case 2 GetIpInfoAv = "document.write(""" & Wry.Country & """);"
  Case 3 GetIpInfoAv = "document.write(""" & Wry.LocalStr & """);"
  Case Else GetIpInfoAv = "document.write(""您来自：" & IP & " 所在区域：" & Wry.Country & " " & Wry.LocalStr & """);"
 End Select
End Function
' ============================================
' 返回QQWry信息(QQWry.Dat版本以及记录条数)
' ============================================
Function WryInfo()
 Dim Wry, IPType, QQWry(1)
 ' 设置类对象
 Set Wry = New TQQWry
 IPType = Wry.QQWry("255.255.255.255")
 ' 读取数据库版本信息
 QQWry(0) = Wry.Country & " " & Wry.LocalStr
 ' 读取数据库IP地址数目
 QQWry(1) = Wry.RecordCount + 1
 WryInfo = QQWry
End Function
' ============================================
' IP物理定位搜索类
' ============================================
Class TQQWry
 ' ============================================
 ' 变量声名
 ' ============================================
 Dim Country, LocalStr, Buf, OffSet
 Private StartIP, EndIP, CountryFlag
 Public QQWryFile
 Public FirstStartIP, LastStartIP, RecordCount
 Private Stream, EndIPOff
 ' ============================================
 ' 类模块初始化
 ' ============================================
 Private Sub Class_Initialize
  Country   = ""
  LocalStr   = ""
  StartIP   = 0
  EndIP    = 0
  CountryFlag  = 0 
  FirstStartIP  = 0 
  LastStartIP  = 0 
  EndIPOff   = 0 
  QQWryFile = Server.MapPath("QQWry.dat") 'QQ IP库路径，要转换成物理路径
 End Sub
 ' ============================================
 ' IP地址转换成整数
 ' ============================================
 Function IPToInt(IP)
  Dim IPArray, i
  IPArray = Split(IP, ".", -1)
  FOr i = 0 to 3
   If Not IsNumeric(IPArray(i)) Then IPArray(i) = 0
   If CInt(IPArray(i)) < 0 Then IPArray(i) = Abs(CInt(IPArray(i)))
   If CInt(IPArray(i)) > 255 Then IPArray(i) = 255
  Next
  IPToInt = (CInt(IPArray(0))*256*256*256) + (CInt(IPArray(1))*256*256) + (CInt(IPArray(2))*256) + CInt(IPArray(3))
 End Function
 ' ============================================
 ' 整数逆转IP地址
 ' ============================================
 Function IntToIP(IntValue)
  p4 = IntValue - Fix(IntValue/256)*256
  IntValue = (IntValue-p4)/256
  p3 = IntValue - Fix(IntValue/256)*256
  IntValue = (IntValue-p3)/256
  p2 = IntValue - Fix(IntValue/256)*256
  IntValue = (IntValue - p2)/256
  p1 = IntValue
  IntToIP = Cstr(p1) & "." & Cstr(p2) & "." & Cstr(p3) & "." & Cstr(p4)
 End Function
 ' ============================================
 ' 获取开始IP位置
 ' ============================================
 Private Function GetStartIP(RecNo)
  OffSet = FirstStartIP + RecNo * 7
  Stream.Position = OffSet
  Buf = Stream.Read(7)
  
  EndIPOff = AscB(MidB(Buf, 5, 1)) + (AscB(MidB(Buf, 6, 1))*256) + (AscB(MidB(Buf, 7, 1))*256*256) 
  StartIP  = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256)
  GetStartIP = StartIP
 End Function
 ' ============================================
 ' 获取结束IP位置
 ' ============================================
 Private Function GetEndIP()
  Stream.Position = EndIPOff
  Buf = Stream.Read(5)
  EndIP = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256) 
  CountryFlag = AscB(MidB(Buf, 5, 1))
  GetEndIP = EndIP
 End Function
 ' ============================================
 ' 获取地域信息，包含国家和和省市
 ' ============================================
 Private Sub GetCountry(IP)
  If (CountryFlag = 1 or CountryFlag = 2) Then
   Country = GetFlagStr(EndIPOff + 4)
   If CountryFlag = 1 Then
    LocalStr = GetFlagStr(Stream.Position)
    ' 以下用来获取数据库版本信息
    If IP >= IPToInt("255.255.255.0") And IP <= IPToInt("255.255.255.255") Then
     LocalStr = GetFlagStr(EndIPOff + 21)
     Country = GetFlagStr(EndIPOff + 12)
    End If
   Else
    LocalStr = GetFlagStr(EndIPOff + 8)
   End If
  Else
   Country = GetFlagStr(EndIPOff + 4)
   LocalStr = GetFlagStr(Stream.Position)
  End If
  ' 过滤数据库中的无用信息
  Country = Trim(Country)
  LocalStr = Trim(LocalStr)
  If InStr(Country, "CZ88.NET") Then Country = ""
  If InStr(LocalStr, "CZ88.NET") Then LocalStr = ""
 End Sub
 ' ============================================
 ' 获取IP地址标识符
 ' ============================================
 Private Function GetFlagStr(OffSet)
  Dim Flag
  Flag = 0
  Do While (True)
   Stream.Position = OffSet
   Flag = AscB(Stream.Read(1))
   If(Flag = 1 or Flag = 2 ) Then
    Buf = Stream.Read(3) 
    If (Flag = 2 ) Then
     CountryFlag = 2
     EndIPOff = OffSet - 4
    End If
    OffSet = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256)
   Else
    Exit Do
   End If
  Loop
  
  If (OffSet < 12 ) Then
   GetFlagStr = ""
  Else
   Stream.Position = OffSet
   GetFlagStr = GetStr() 
  End If
 End Function
 ' ============================================
 ' 获取字串信息
 ' ============================================
 Private Function GetStr() 
  Dim c
  GetStr = ""
  Do While (True)
   c = AscB(Stream.Read(1))
   If (c = 0) Then Exit Do 
   
   '如果是双字节，就进行高字节在结合低字节合成一个字符
   If c > 127 Then
    If Stream.EOS Then Exit Do
    GetStr = GetStr & Chr(AscW(ChrB(AscB(Stream.Read(1))) & ChrB(C)))
   Else
    GetStr = GetStr & Chr(c)
   End If
  Loop 
 End Function
 ' ============================================
 ' 核心函数，执行IP搜索
 ' ============================================
 Public Function QQWry(DotIP)
  Dim IP, nRet
  Dim RangB, RangE, RecNo
  
  IP = IPToInt (DotIP)
  
  Set Stream = CreateObject("ADodb.Stream")
  Stream.Mode = 3
  Stream.Type = 1
  Stream.Open
  Stream.LoadFromFile QQWryFile
  Stream.Position = 0
  Buf = Stream.Read(8)
  
  FirstStartIP = AscB(MidB(Buf, 1, 1)) + (AscB(MidB(Buf, 2, 1))*256) + (AscB(MidB(Buf, 3, 1))*256*256) + (AscB(MidB(Buf, 4, 1))*256*256*256)
  LastStartIP  = AscB(MidB(Buf, 5, 1)) + (AscB(MidB(Buf, 6, 1))*256) + (AscB(MidB(Buf, 7, 1))*256*256) + (AscB(MidB(Buf, 8, 1))*256*256*256)
  RecordCount = Int((LastStartIP - FirstStartIP)/7)
  ' 在数据库中找不到任何IP地址
  If (RecordCount <= 1) Then
   Country = "未知"
   QQWry = 2
   Exit Function
  End If
  
  RangB = 0
  RangE = RecordCount
  
  Do While (RangB < (RangE - 1)) 
   RecNo = Int((RangB + RangE)/2) 
   Call GetStartIP (RecNo)
   If (IP = StartIP) Then
    RangB = RecNo
    Exit Do
   End If
   If (IP > StartIP) Then
    RangB = RecNo
   Else 
    RangE = RecNo
   End If
  Loop
  
  Call GetStartIP(RangB)
  Call GetEndIP()

  If (StartIP <= IP) And ( EndIP >= IP) Then
   ' 没有找到
   nRet = 0
  Else
   ' 正常
   nRet = 3
  End If
  Call GetCountry(IP)

  QQWry = nRet
 End Function
 ' ============================================
 ' 类终结
 ' ============================================
 Private Sub Class_Terminate
  On ErrOr Resume Next
  Stream.Close
  If Err Then Err.Clear
  Set Stream = Nothing
 End Sub
End Class 
%>

<% '——————调用方法 ——————%>
<% '——————0是显示样式类型——————%>
