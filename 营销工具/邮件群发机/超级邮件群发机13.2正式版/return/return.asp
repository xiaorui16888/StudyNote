<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="adovbs.inc"-->
<!--#include File="inc_c_return.asp"-->
<%
	dim email, how
	email=Request.QueryString("email")
	how=Request.QueryString("how")
	
	Dim cls_return
	
	set cls_return = new class_return
	
	on Error Resume next
	
	cls_return.OpenConnect
	
	if how="vrfy" then
		if Err.number <> 0 then
			Response.Write "Vrfy Failed"&chr(13)&chr(10)
			Response.Write Err.Description
		else
			Response.Write "Vrfy OK"
		end if
	end if
	
	if email<>"" then
		if Instr( "{RECEIVER_ADDRESS}", email ) > 0 then
		else
			cls_return.InsertEmail( email )
		end if	
	end if
	
	if how="clear" then
		if cls_return.DeleteEmails then
			Response.Write "Delete OK"
		end if 
	end if
	
	if how="list" then
		cls_return.OutputList
	end if
	
	cls_return.CloseConnect
	set cls_return=nothing
%>


