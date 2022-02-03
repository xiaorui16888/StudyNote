<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->
<!--#include File="inc_c_return.asp"-->
<!--#include File="inc_head.asp"-->

<form action="return_view.asp?how=query" method=post id=fm_query name=fm_query>
<%writehead 2%>
<table align=center border=1 width=500 cellspacing=0 cellpadding=5 bgcolor=gold  bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr height=35>
<td style="width:100px"><b>操作：</b>
<% if Request.QueryString("how")<>"" then %>
<input value=返回 type=button onclick="window.navigate('return_view.asp')">
<% else %>
<input value=刷新 type=button onclick=" window.navigate( window.location );return false;">
<% end if %>
</td><td>
邮件地址&nbsp;<input type=text name=email>&nbsp;<input type=submit value="搜索">
</td><td style="width:50px; text-align:center">
<input value=退出 type=button language=javascript onclick="window.navigate('stat_login.asp?logout=true');return false;" id=button3 name=button3>
</td></tr></table>
<br>
</form>
<%
 	Dim cls_return
	set cls_return = new class_return
	cls_return.OpenConnect

	if Request.Form("how")="del" then
		' 执行删除
		Dim delidarray
		delidarray = Split(Request.Form("selid"), ",")
	
		if UBound(delidarray)>=0 then
			dim i, selstr
			selstr = "where ( id="&delidarray(0)
			for i=1 to UBound(delidarray)
				if IsNumeric( delidarray(i) ) then
					selstr = selstr&" or id="&delidarray(i)
				end if
			next
			selstr = selstr + " )"
				
			'Microsoft.Jet.OLEDB.4.0
			'打开数据库
			Dim strCnn

			On Error Resume Next
			
	        cls_return.execsql "delete from return "& selstr
	
			if Err.number<>0 then
				Response.Write "<H1>处理错误"&Err.number&"</H1><br>"
				Response.Write Err.Description&"<br>"
				Response.End
			end if
		else
			Response.Write "<h1>未选中任何记录</h1>"
			Response.End 
		end if
	end if

    ' 查询 SQL 命令
	dim cmd
	set cmd = Server.CreateObject("ADODB.Command")
	if Request.QueryString("how")="query" then
		dim email
		email = get_request( true, "email" )
		
		cmd.CommandText = "select * from return where email=? order by email;"
		' 参数
		dim p1
        Set p1 = cmd.CreateParameter ("@P1", adVarChar, 1, 256, email )
		cmd.Parameters.Append p1
		cmd.CommandType=adCmdText
		
		' 列举数据
		cls_return.getrecords cmd, rs
	else
		cmd.CommandText = "select * from return order by email;"
		' 列举数据
		cls_return.getrecords cmd, rs
	end if
%>
<%
	'  设置页数
	dim page	page = Request.QueryString("page")
	if page="" then		page=Request.Form("page")	end if
	if page = "" then
		page = 1
	end if	
	rs.PageSize = getpagesize(2)
		if rs.PageCount>0 then
		rs.AbsolutePage = page	end if
%>
<form action="" method=post name=fm_delsel LANGUAGE=javascript onsubmit="return fm_delsel_onsubmit()">
<input type="hidden" name="how" value="">
<table align=center width=500 border="1" cellspacing="0" bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
	<tr height=20 bgcolor=MintCream>
	<td align=center width=40><input type=checkbox style="border-color:white" id=m_selall LANGUAGE=javascript onclick="return m_selall_onclick()"></td>
	<td align=center width=240>邮件地址</td>
	<td align=center width=100>次数</td>
	<td align=center width=240>最后一次退订时间</td></tr>
<%		
	if rs.RecordCount>0 then
		dim num
		num = 0
		while not rs.EOF and num<rs.PageSize
			num = num + 1
%>
	<tr height=20>
		<td align=center><input type=checkbox style="border-color:white" id=selid<%=num%> name=selid value="<%=rs("id")%>"></td>
		<td><%=rs("email")%></td>
		<td><%=rs("n")%></td>
		<td><%=rs("lasttime")%></td>
	</tr>
<%
			rs.MoveNext
		wend
%>
<script type="text/javascript">

function fm_delsel_onsubmit() {
	if ( window.confirm("你确定要删除选择的记录吗？") )
	{
	    fm_delsel.how.value="del";
	    fm_delsel.action=window.location;

		return true;
	}
	return false;
}

function m_selall_onclick() {
	var a = window.fm_delsel.m_selall.checked	
<%
	for i=1 to num
		response.write "window.fm_delsel.selid" & i &".checked=a;"&chr(13)&chr(10)
	next
	
%>
}

</script>
<%
	end if
%>

	<tr><td colspan=4><input type=submit value="删除选择的记录"></td></tr>
	</table>
</form>
<!--#include file="page.asp"-->
<%	WritePageSelection "?query=0", rs.PageCount, page %>

<%		
	Connect.Close
	cls_return.CloseConnect
	set cls_return=nothing
%>
</body>
</html>