<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="inc_md5.asp"-->
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->
<!--#include File="inc_head.asp"-->
<%
	dim f,fp
	
	'on Error Resume next
	dim selstr, sortby, sc
	sortby = Request.QueryString("sortby")
	if sortby="" then
		sortby = Request.Cookies("sortby_mailidlist")
		sc = Request.Cookies("sc_mailidlist")
	else
		if Request.Cookies("sc_mailidlist")="" then
			sc="ASC"
			Response.Cookies("sc_mailidlist")="ASC"
		else
			if Request.Cookies("sc_mailidlist")="ASC" then
				sc="DESC"
				Response.Cookies("sc_mailidlist")="DESC"
			else
				sc="ASC"
				Response.Cookies("sc_mailidlist")="ASC"
			end if	 		
		end if
	end if
	
	selstr = "select * from stat"
	' Sortby
	if sortby<>"" then
		Response.Cookies("sortby_mailidlist")=sortby
		selstr = selstr & " order by " & sortby & " " & sc
	end if	
	
	rs.Open selstr, Connect,adOpenKeyset, adLockReadOnly
		
%>
<%
	'  设置页数
	dim page	page = Request.QueryString("page")
	if page="" then		page=Request.Form("page")	end if
	if page = "" then
		page = 1
	end if	
	rs.PageSize = getpagesize(1)
		if rs.PageCount>0 then
		rs.AbsolutePage = page	end if
%>
<form action="stat_query.asp" method="get">
<% writehead 1 %>
<table align=center border=1 width=500 cellspacing=0 cellpadding=5 bgcolor=gold  bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr height=35>
<td style="width:100px"><b>操作：</b>
<input value=刷新 type=button onclick="window.location.reload();return false;">
</td><td>
<input type=radio value="0" name=qtype Checked style="border:0px;">Email<input type=radio value="1" name=qtype style="border:0px;">IP
<input type=text name=q>
<input type=submit value="搜索">
</td><td style="width:50px; text-align:center">
<input value=退出 type=button language=javascript onclick="window.navigate('stat_login.asp?logout=true');return false;" id=button3 name=button3>
</td></tr></table><br>
</form>
<table align=center width=500 border="1" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
	<tr height=20 bgcolor=MintCream>
		<td align="center" style="width:100px"><a href=?sortby=mail_id>邮件标识</a><%write_sortsign "mail_id", sortby%></td>
		<td align="center" style="width:100px"><a href=?sortby=mail_read>访问次数</a><%write_sortsign "mail_read", sortby%></td>
		<td align="center" style="width:300px">操作</td></tr>
<%		
	if rs.RecordCount>0 then
		dim num
		num = 0
		while not rs.EOF and num<rs.PageSize
			num = num + 1
%>
	<tr height="20">
		<td align="left"><%=rs("mail_id")%></td>
		<td align="right" style="padding-right:10px"><%=rs("mail_read")%></td>
		<td align="center">
			<a href="stat_lists.asp?mail_id=<%=rs("id")%>">详细记录</a>
			<a href="stat_times.asp?mail_id=<%=rs("id")%>">查看次数</a>
			<a href="" onclick="showdlg('删除此邮件的所有记录','stat_opt.asp?del=true&mail_id=<%=rs("id")%>');return false;" >删除</a>
		</td>
	</tr>
<%
			rs.MoveNext
		wend
	end if
%>
	</table>
<!--#include file="page.asp"-->
<%	WritePageSelection "?query=0", rs.PageCount, page %>

<%		
	rs.Close
	Connect.Close
%>
</body>
</html>