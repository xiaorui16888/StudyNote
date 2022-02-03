<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->
<!--#include File="inc_head.asp"-->
<%
	dim mail_id, mail_idname
	mail_id = get_request( false, "mail_id" )
	
	if mail_id="" then
		mail_id = Request.Cookies("mail_id")	
	end if
	if mail_id<>"" then
		Response.Cookies("mail_id")=mail_id
	else
		Response.Write "无效 ID"
		Response.End
	end if
	
	dim f,fp

	dim selstr
	
	' mail_id 必须是数字
	if not IsNumeric( mail_id ) then
		Response.Write "mail_id 参数错误"
		Response.End
	end if
	
	selstr = "select * from stat where id="&mail_id
	rs.Open selstr, Connect,adOpenKeyset, adLockReadOnly
	if rs.RecordCount>=1 then
		mail_idname = rs("mail_id")
	end if
	rs.Close()

	selstr = "select email, times, maxdate from ( select email, count(email) as times, max(date) as maxdate from list where mailid="&mail_id&" group by email )"
	' 排序
	dim sortby, sc
	sortby = Request.QueryString("sortby")
	
	if sortby="" then
		sortby = Request.Cookies("sortby_times")
		sc = Request.Cookies("sc_times")
	else
		' 升序、降序
		if Request.Cookies("sc_times")="" then
			sc="ASC"
			Response.Cookies("sc_times")="ASC"
		else
			if Request.Cookies("sc_times")="ASC" then
				sc="DESC"
				Response.Cookies("sc_times")="DESC"
			else
				sc="ASC"
				Response.Cookies("sc_times")="ASC"
			end if	 		
		end if
	end if
	
	if sortby="" or ( sortby<>"email" and sortby<>"times" and sortby<>"maxdate") then
		sortby = "email"
	end if
	
	' 保存排序依据、添加到 SQL 字符串
	Response.Cookies("sortby_times")=sortby

	selstr = selstr & " order by " & sortby & " " & sc
	
	rs.Open selstr, Connect, adOpenKeyset, adLockReadOnly		
	
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
<tr><td>
<b>操作：</b>
<input type=button value=首页 onclick="window.navigate('stat_view.asp');" id=button2 name=button2>
<input value=返回上一级 type=button onclick="gopre();" id=button1 name=button1>
</td><td height=20>
邮件标识：<%=mail_idname%>
</td></tr></table><br>
<table align=center width=500 border="1" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
	<tr height=20 bgcolor=MintCream>
		<td align=center><a href=?sortby=email>收件人邮件地址</a><%write_sortsign "email", sortby%></td>
		<td align=center><a href=?sortby=times>次数</a><%write_sortsign "times", sortby%></td>
		<td align=center><a href=?sortby=maxdate>最后一次查看时间</a><%write_sortsign "maxdate", sortby%></td>
	<td align=center>操作</td></tr>
<%		
	if rs.RecordCount>0 then
		dim num
		num = 0
		while not rs.EOF and num<rs.PageSize
			num = num + 1
%>
	<tr height=20>
		<td><%=rs("email")%></td>
		<td align=right><%=rs("times")%></td>
		<td align=center><%=rs("maxdate")%></td>
		<td><a href="stat_query.asp?q=<%=rs("email")%>">查看详细记录</a></td>
	</tr>
<%		
			rs.MoveNext
		wend
	end if
	
	

%>
	</table>
<!--#include file="page.asp"-->
<%	WritePageSelection "?mail_id=" & mail_id, rs.PageCount, page %>

</body>
</html>
<%		
	rs.Close
	Connect.Close
%>