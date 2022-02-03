<%@ Language=VBScript codepage=65001%>
<!--#include File="adovbs.inc"-->
<!--#include File="inc_funcs.asp"-->
<%
    dim Connect, rs
    set Connect = Server.CreateObject("ADODB.Connection")
    set rs = Server.CreateObject("ADODB.Recordset")
%>
<%	
	dim mail_id, vrfy, email
	vrfy=Request.QueryString("vrfy")
	email=Request.QueryString("email")
	mail_id = Trim( Request.QueryString( "mail_id" ) )
	
	dim f,fp
%>
<!--#include File="inc_conn.inc"-->
<%
	Dim selstr

	if vrfy<>"" then
		if Err.number <> 0 then
			Response.Write "Vrfy Failed"&chr(13)&chr(10)
			Response.Write Err.Description
		else
			Response.Write "Vrfy OK"
		end if
		Response.End
	end if
	
	if mail_id<>"" and len(mail_id)>0 and Instr( email, "@" )>1 then
	
		'读取黑白名单设置
		dim list_white, list_black, b_useblack, b_usewhite, blacks, whites
		rs.Open "setup", Connect,adOpenKeyset,adLockOptimistic 
		b_useblack = rs("buseblack") 
		b_usewhite = rs("busewhite")
		whites = rs("whitelist")
		blacks = rs("blacklist")
		if isnull(whites)=false then
			list_white = Split( whites, chr(13)&chr(10) )
		end if
		if isnull( blacks)=false then
			list_black = Split( blacks, chr(13)&chr(10) )
		end if
		rs.Close
		
		dim i, bfind, badd
		
		'检查白名单
		if b_usewhite then
			badd = false
			for i=0 to UBound(list_white)
				if StrComp( mail_id, list_white(i),vbTextCompare )=0 then
					bfind = true
					exit for
				end if
			next
			if bfind=true then
				badd = true
			end if
		else
			'检查黑名单
			badd=true
			if b_useblack then
				for i=0 to UBound(list_black)
					if StrComp( mail_id, list_black(i),vbTextCompare )=0 then
						bfind = true
						exit for
					end if
				next
				if bfind=true then
					badd = false
				end if	
			end if
		end if
		
		if Err.number<>0 then
			Response.Write Err.Description
		end if
			
		' 需要添加记录
		if badd then	
		    ' 使用 Command , 参数 SQL
		    dim cmd, p1
		    set cmd = Server.CreateObject("ADODB.Command")
		    cmd.CommandText = "SELECT * FROM [stat] WHERE mail_id=?;"
            Set p1 = cmd.CreateParameter ("@P1", adVarChar, 1, 20, mail_id )
		    cmd.Parameters.Append p1
    		cmd.ActiveConnection=Connect
		    rs.Open cmd,,adOpenKeyset, adLockOptimistic
			
			'添加统计记录
			if rs.RecordCount>0 then
				rs("mail_read") = rs("mail_read")+1
				rs.Update
			else
				rs.AddNew
				rs("mail_id")=mail_id
				rs("mail_read")=1
				rs.Update
			end if
		
			dim id
			id = rs("id")
		
			'添加详细记录
			rs.Close
			rs.Open "select top 1 * from list", Connect, adOpenKeyset, adLockOptimistic
			rs.AddNew()
			rs("mailid")= id
			rs("ip")    = Request.ServerVariables("REMOTE_ADDR")
			rs("client")= Request.ServerVariables("HTTP_USER_AGENT")
			rs("email") = email
			rs("date")  = Now()
			rs.Update
		
			rs.Close
		end if
	end if
	Connect.Close
%>
<%
    dim st
    set st = Server.CreateObject("ADODB.Stream")

	Response.ContentType = "image/gif"

	Response.Buffer = true
	
	st.Open
	st.Type = 1
	st.LoadFromFile( Server.MapPath("blank.gif") )
	Response.BinaryWrite st.Read
	st.Close
	
	Response.Flush
%>