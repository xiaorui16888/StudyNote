<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="inc_md5.asp"-->
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->
<table border=1 width=400 align=center cellspacing=0 cellpadding=5 bordercolorlight="#C0C0C0" bordercolordark="#FFFFFF">
<tr style="background-color:gold"><td><div style="font-size:14px; font-weight:bold;">综合设置</div></td></tr>
<tr>
<td>
<%
	dim how
	how=Request.QueryString("how")
	if how="save" then
		
		on error resume next
		
		dim mainpgsize,listpgsize, bcheckok
		mainpgsize=Request.Form("mainpgsize")
		listpgsize=Request.Form("listpgsize")
		
		dim editpass, password, username
		editpass = Request.Form("editpass")
		username = Trim( Request.Form("username") )
		password = Trim( Request.Form("password1") )
		
		bcheckok=true
		if editpass="on" then
			if Len( username )<1 then
				Response.Write "新用户名不能为空"	
				bcheckok=false
			end if
			if Len( password )<5 then
				Response.Write "新密码长度不能小于 5 个字符"	
				bcheckok=false
			end if
		end if
		
		if mainpgsize="" or listpgsize="" or IsNumeric(mainpgsize)=false or IsNumeric(listpgsize)=false then
			Response.Write "请填写完整，并且每页显示数量必须填写数字"	
			bcheckok=false
		end if
		
		if bcheckok=True then
			if (mainpgsize<1 or mainpgsize>1000) or (listpgsize<1 or listpgsize>1000) then
				Response.Write "请设置1～1000的每页显示数量。页面数量过大会造成显示速度变化，加重服务器负担。"
				bcheckok=false
			end if
		end if

		if bcheckok=True then
			rs.Open "select * from setup where id=1", Connect, adOpenKeyset, adLockOptimistic
			rs("mainpgsize")=mainpgsize
			rs("listpgsize")=listpgsize
			rs.Update
			if Err.number<>0 then
				Response.Write "<h3>设置保存失败：" & Err.Description & "</h3>"
			else
				Response.Write "<h3>设置保存完毕。</h3>"
			end if
			Err.Clear
			
			'修改密码
			if editpass="on" then
			
			dim fs, a
				Set fs = CreateObject("Scripting.FileSystemObject")
				Set a = fs.CreateTextFile( Server.MapPath("inc_userpass.inc"), True )
				a.WriteLine( "<%")
				a.WriteLine( "'登录用户名密码")
				a.WriteLine( "cuser=""" & username & """	'用户名")
				a.WriteLine( "cpass=""" & md5(password) & """	'密码")
				a.Write(     "%" )
				a.WriteLine( ">")
				a.Close

				if Err.number<>0 then
					Response.Write "<h3>帐户信息保存失败：" & Err.Description & "</h3>"
				else
					Response.Write "<h3>帐户信息保存完毕。</h3>"
				end if
			end if
		end if
	else 
		rs.Open "setup", Connect, adOpenKeyset, adLockOptimistic
%>
<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>
<!--

function fm_other_onsubmit() {
	if ( fm_other.editpass.checked==true )
	{
		if ( fm_other.username.value.length<=0 )
		{
			window.alert("新用户名不能为空！" );
			return false;
		}
		if ( fm_other.password1.value.length< 5 )
		{
			window.alert("密码长度不能小于 5 个字符！" );
			return false;
		}
		
		if ( fm_other.password1.value != fm_other.password2.value )
		{
			window.alert("两次输入的密码不一致！" );
			return false;
		}
	}
}

//-->
</SCRIPT>
<form method=post action="?how=save" name=fm_other LANGUAGE=javascript onsubmit="return fm_other_onsubmit()">
邮件标识列表每页显示数量：<input type=text name=mainpgsize style="width:60px;" value=<%=getpagesize(1)%>><br>
其他统计列表每页显示数量：<input type=text name=listpgsize style="width:60px;" value=<%=getpagesize(2)%>><br>
<br>

<div style="border:1px #ccddff solid; background:#eef4ff;">
<div style="margin:4px;">
新　用户名：<input type=text name=username value=<%=cuser%>><br>
输入新密码：<input type=password name=password1><br>
新密码确认：<input type=password name=password2><br>
<br>
<input type=checkbox name=editpass value="on" style="border:0px white none" id=m_editpass>
<label for="m_editpass">保存用户名、密码</label><br>
</div>
</div>
<br>
<input type=submit value="保存设置"><input type=reset value="恢复">
</form>
<%	end if	%>

<%	Connect.Close %>
</td></tr></table>
</body>
</html>