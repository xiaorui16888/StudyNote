<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->

<table border=1 width=400 align=center cellspacing=0 cellpadding=5 bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr style="background-color:gold"><td><div style="font-size:14px; font-weight:bold">设置邮件标识黑名单</div></td></tr>
<tr>
<td>
<%
	dim how
	how=Request.QueryString("how")
	if how="save" then
		
		on error resume next

		rs.Open "select * from setup where id=1", Connect, adOpenKeyset, adLockOptimistic
		if Request.Form("buseblack")="on" then
			rs("buseblack")=true
		else
			rs("buseblack")=false
		end if
		
		dim mailids
		mailids = Request.Form("mailids")
		
		'去掉多余的空行
		dim lines
		lines = Split( mailids, Chr(13)&chr(10), -1, vbTextCompare )
		
		dim i
		mailids=""
		for i = 0 to UBound( lines )
			lines(i) = Replace( lines(i), chr(13), "" )
			lines(i) = Replace( lines(i), chr(10), "" )
			lines(i) = Trim( lines(i))
			if Len( CStr(lines(i)) )>0 then 
				mailids = mailids & lines(i)
				if i<UBound( lines ) then
					mailids = mailids & chr(13) & chr(10)
				end if
			end if
		next
		'保存
		rs("blacklist")=mailids
		rs.Update
		rs.Close
		Connect.Close	

		if Err.number<>0 then
			Response.Write "<h3>保存失败：" & Err.Description & "</h3>"
		else
			Response.Write "<h3>保存完毕。</h3>"
		end if

	else 
		rs.Open "setup", Connect, adOpenKeyset, adLockOptimistic
%>
说明：设置邮件标识黑名单，可以让以后遇到此类邮件标识不再统计。
<form method=post action="?how=save">
<input type=checkbox name=buseblack style="border-color:white" <%if rs("buseblack") then Response.Write "Checked" end if%>>启用邮件标识黑名单<br>
<textarea name="mailids" style="width:200px;height:120px"><%
	
	Response.Write rs("blacklist")
	rs.Close
	Connect.Close
%>
</textarea><br>
上边边输入邮件标识，每行一个<br>
<br>
<input type=submit value="保存设置"><input type=reset value="恢复">
</form>
<%	end if	%>
</td></tr></table>
</body>
</html>