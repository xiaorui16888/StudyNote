<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="inc_md5.asp"-->
<!--#include File="stat_inc.asp"-->
<%
	'是否注销
	dim blogout
	blogout = Request.QueryString("logout")
	if Cbool(blogout)=true then
		Session("seid_stat_login")=""
		Response.Cookies("seid_stat_login")=""
		
		Response.Write "<script type=""text/javascript"">window.onload=function(){window.alert(""您已成功退出登录~"");}</script>"
		blogin = false
	end if 
	
	if Cbool(blogin)=false then
		dim user, pass
		
		user = Request.Form("user")
		pass = Request.Form("pass")
		
		' 下边可以修改用户名和密码
		if user=cuser and md5(pass)=cpass then
			Randomize 
			dim seid, i
			'创建 SEID 随机20位字母
			seid = ""
			for i=1 to 20
				seid = seid & Chr( Int((26 * Rnd) + 0) +97)
			next

			Response.Cookies("seid_stat_login") = seid
			
			Session.Timeout = 10
			Session("seid_stat_login")=seid
			
			Response.Redirect "stat_view.asp"
		else
			' 显示登录输入窗口
			if user<>"" and pass<>"" then
				Response.Write "<script type=""text/javascript"">window.onload=function(){window.alert(""用户名或注册码错误，请重新输入！"");}</script>"
			end if
			
			WriteLoginForm
		end if
	else
	    Response.Redirect "stat_view.asp"
	end if  
%>
</body>
</html>

<%
	Sub WriteLoginForm()
%>
<table align="center" border="1" width="350" cellspacing="0" cellpadding="5" bgcolor="white"  bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr style="background-color:gold">
<td><div style="font-size:14px; font-weight:bold">输入用户名、密码验证管理身份</div></td>
</tr>
<tr><td>		
	<form action="stat_login.asp" method="POST" id="form1" name="form1">	<p style="padding:20px; line-height:160%">	用户名：<input type="text" name="user" style="width:120" /><br />	密　码：<input type="password" name="pass" style="width:120" /><br />	　　　　<input type="submit" value="登录"  style="width:80" /><br />
	</p>
	</form>
</td></tr>
</table>
<%
	End Sub
%>