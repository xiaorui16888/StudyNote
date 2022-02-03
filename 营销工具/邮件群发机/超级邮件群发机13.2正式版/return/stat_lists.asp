<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_c_CheckUserAgent.asp"-->
<!--#include File="inc_checklogin.asp"-->
<!--#include File="inc_stat_functions.asp"-->
<!--#include File="inc_head.asp"-->

<style type="text/css">
.sign {
	font-family: Webdings;
}
</style>

<%
	dim mail_id, mail_idname
	mail_id = get_request( false, "mail_id" )
	if not IsNumeric( mail_id ) then
		Response.Write "mail_id 参数错误"
		Response.End
	end if
	
	dim sortby, sc
	sortby = get_request( false, "sortby")
	if sortby = "" then
		sortby = "date"
	end if
	
	sc = get_request( false, "sc")
	if sc<>"ASC" and sc<>"DESC" then
		sc = "ASC"
	end if
	
	dim f,fp
	dim selstr
	
	selstr = "select * from stat where id="&mail_id
	rs.Open selstr, Connect,adOpenKeyset, adLockReadOnly
	if rs.RecordCount>=1 then
		mail_idname = rs("mail_id")
	end if
	rs.Close()

	selstr = "select * from list where mailid="&mail_id & " order by [" & sortby & "] " & sc & ";"
	rs.Open selstr, Connect,adOpenKeyset, adLockReadOnly	
%>
<%
	'  设置页数
	dim page	page = Request.QueryString("page")	if page="" then		page=Request.Form("page")	end if
	if page = "" then
		page = 1
	end if
	rs.PageSize = getpagesize(2)
		if rs.PageCount>0 then
		rs.AbsolutePage = page	end if
%>

<% writehead 1 %>
<table align=center border=1 width=500 cellspacing=0 cellpadding=5 bgcolor=gold  bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr><td height=20>
<b>操作：</b>
<input type=button value=首页 onclick="window.navigate('stat_view.asp');" id=button2 name=button2>
<input value=返回上一级 type=button onclick="gopre();" id=button1 name=button1>
</td>
<td height=20>
邮件标识：<%=mail_idname%>
</td></tr>
</table>
<br>
<table align=center width=700 border="1" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
	<tr height=20 bgcolor=MintCream>
		<td><a href="?mail_id=<%=mail_id%>&sortby=email<%=write_sortpara( sortby, "email")%>">收件人地址</a><%write_sortsign "email", sortby%></td>
		<td><a href="?mail_id=<%=mail_id%>&sortby=ip<%=write_sortpara( sortby, "ip")%>">访问IP</a><%write_sortsign "ip", sortby%></td>
		<td>地区</td>
		<td><a href="?mail_id=<%=mail_id%>&sortby=date<%=write_sortpara( sortby, "date")%>">访问日期</a><%write_sortsign "date", sortby%></td>
		<td>操作系统</td><td>浏览器</td>
	</tr>

<%		
	if rs.RecordCount>0 then
		dim num, cua
		num = 0
		set CUA=new CheckUserAgent
		while not rs.EOF and num<rs.PageSize
			num = num + 1
			
			' 防止 CheckUserAgent 出错
			on error resume next
			
			CUA.execute rs("client")
%>
	<tr height=20><td><%=rs("email")%></td><td><%=rs("ip")%></td><td><%=findArea(rs("ip"))%></td>
	<td><%=rs("date")%></td>
		<td><%=cua.vos%>&nbsp;</td>
		<td><%=cua.vsoft%>&nbsp;</td>
	</tr>
<%
			Err.Clear 
			
			rs.MoveNext
		wend
	end if	
%>
	</table>
	<br>
	
<!--#include file="page.asp"-->
<%	WritePageSelection "?mail_id="&mail_id&"&sortby="&sortby, rs.PageCount, page %>
</body>
</html>
<%
	rs.Close
	Connect.Close
%>