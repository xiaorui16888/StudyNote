<!--#include File="inc_ip.asp"-->

<%

' ********************************************************
'                自 定 义 函 数 和 子 程 序
' ********************************************************

' 找到IP地址对应的地区
function findArea(vIP)
	on error resume next
	dim fs
	set fs = Server.CreateObject("Scripting.FileSystemObject")
	if fs.FileExists( Server.MapPath("qqwry.dat") )=false then
		findArea="未找到QQWry.dat"
		exit function
	end if
	
	Err.number = 0
	
	findArea = Look_Ip( vIP ) 
	
	if Err.number<>0 then
		Response.Write Err.Description
	end if
end function

function findArea_mdb(vIP)
	on error resume next
	dim fs
	set fs = Server.CreateObject("Scripting.FileSystemObject")
	if fs <> null then
		if fs.FileExists( Server.MapPath("ip.mdb") )=false then
			findArea="未找到IP.MDB"
			fs = null
			exit function
		end if
		fs = null
	end if
	Err.number = 0

	dim inIP,inIPnum,inIPs, connip, rsip
	inIP=vip
	inIPs=split(inIP,".")
	inIPnum=16777216*inips(0) + 65536*inips(1) + 256*inips(2) + inips(3)
	set connip=server.createobject("adodb.connection")
	connip.Open "driver={Microsoft Access Driver (*.mdb)};dbq=" & Server.MapPath("ip.mdb")
	set rsip=connip.Execute("select ip1,ip2,country from address where ip2>="&inipnum&" and ip1<=" _
		& inipnum & " order by ip2-ip1")
	if rsip.eof then
		findArea=""
	else
		findArea=rsip("country")
		if instr(findarea,"未知") then findarea=""
	end if
	if Err.number<>0 then
		findArea = Err.Description 
	end if
	connip.Close
end function

Function URLDecode(enStr)
  dim deStr
  dim c,i,v
  deStr=""
  for i=1 to len(enStr)
    c=Mid(enStr,i,1)
    if c="%" then
      v=eval("&h"+Mid(enStr,i+1,2))
      if v<128 then
        deStr=deStr&chr(v)
        i=i+2
      else
        if isvalidhex(mid(enstr,i,3)) then
          if isvalidhex(mid(enstr,i+3,3)) then
            v=eval("&h"+Mid(enStr,i+1,2)+Mid(enStr,i+4,2))
            deStr=deStr&chr(v)
            i=i+5
          else
            v=eval("&h"+Mid(enStr,i+1,2)+cstr(hex(asc(Mid(enStr,i+3,1)))))
            deStr=deStr&chr(v)
            i=i+3 
          end if 
        else 
          destr=destr&c
        end if
      end if
    else
      if c="+" then
        deStr=deStr&" "
      else
        deStr=deStr&c
      end if
    end if
  next
  URLDecode=deStr
end function

function isvalidhex(str)
  isvalidhex=true
  str=ucase(str)
  if len(str)<>3 then isvalidhex=false:exit function
  if left(str,1)<>"%" then isvalidhex=false:exit function
  c=mid(str,2,1)
  if not (((c>="0") and (c<="9")) or ((c>="A") and (c<="Z"))) then isvalidhex=false:exit function
  c=mid(str,3,1)
  if not (((c>="0") and (c<="9")) or ((c>="A") and (c<="Z"))) then isvalidhex=false:exit function
end function

%>