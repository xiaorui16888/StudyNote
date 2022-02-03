<%
	function getpagesize( a )
		on error resume next
		Dim rs_setup
		set rs_setup = Server.CreateObject("ADODB.Recordset")
	
		if a=1 then
			rs_setup.Open "select mainpgsize from setup",Connect
			getpagesize = rs_setup("mainpgsize")
		end if
		if a=2 then
			rs_setup.Open "select listpgsize from setup",Connect
			getpagesize = rs_setup("listpgsize")
		end if
		rs_setup.Close
		
		if getpagesize<0 or getpagesize="" then
			getpagesize=30
		end if	
	end function
	
	function write_sortsign( name, curname )
		if Strcomp( name, curname, vbTextCompare ) = 0 then
			if sc = "DESC" then
				Response.Write "<span style=""font-family: Webdings"">6<span>"
			else
				Response.Write "<span style=""font-family: Webdings"">5<span>"
			end if
		end if
	end function
	
	function write_sortpara( name, curname )
		if Strcomp( name, curname, vbTextCompare ) = 0 then
			if sc = "DESC" then
				Response.Write "&sc=ASC"
			else
				Response.Write "&sc=DESC"
			end if
		end if
	end function
	
	function get_request( bform, name )
		dim rtntext
		if bform then
			rtntext = Request.Form(name)
		else
			rtntext = Request.QueryString(name)
		end if
		
		get_request = Trim(rtntext)
	
	end function
%>