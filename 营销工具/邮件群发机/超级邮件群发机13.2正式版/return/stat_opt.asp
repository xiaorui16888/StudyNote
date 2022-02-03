<%@ Language=VBScript codepage=936%>
<%Option Explicit%>
<!--#include File="stat_inc.asp"-->
<!--#include File="inc_checklogin.asp"-->

<%
	dim mail_id
	mail_id = get_request( false, "mail_id" )
	if not IsNumeric( mail_id ) then
		Response.Write "mail_id ²ÎÊý´íÎó"
		Response.End
	end if
	
	dim f,fp
	
	'on Error Resume next
	
	Dim selstr
	
	Response.Write "Delete...<br>"
	
	if  Request.QueryString("del")="true" then
		if mail_id<>"" then
			selstr = "delete * from list where mailid="&mail_id
			rs.Open selstr, Connect,adOpenKeyset,adLockOptimistic
			selstr = "delete * from stat where id="&mail_id  
			rs.Open selstr, Connect,adOpenKeyset,adLockOptimistic
			Response.Write "Deleted.<br>"
		else
			selstr = "delete * from stat"
			rs.Open selstr, Connect,adOpenKeyset,adLockOptimistic 
			selstr = "delete * from list"
			rs.Open selstr, Connect,adOpenKeyset,adLockOptimistic 
		end if
	end if

	Connect.Close	
	
	dim url
	url = Replace( Request.QueryString("url"), "%26", "&" )
	
	Response.Redirect url
%>
