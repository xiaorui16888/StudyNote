<style type="text/css">
.border_nosel {
	border-width: 0px 0px 0px 0px;
	border-style: solid;
	background-color: MintCream;
	border-top-color: #00FF00;
	border-right-color: #008000;
	border-left-color: #00FF00;
}
.border_cusel {
	border-width: 1px 1px 0px 1px;
	border-style: solid;
	background-color: gold;
	border-top-color: #C0C0C0;
	border-right-color: #C0C0C0;
	border-left-color: #C0C0C0;
}
</style>
<%
	function writehead( headtype )
%>
<table align=center border=0 width=500 cellspacing=0 cellpadding=1>
<tr height=20>
	<%dim ba%>
	<%if headtype=1 then ba=false else ba=true end if%>
	<%writehead_sub "统计管理", "stat_view.asp", ba%>
	<%if headtype=2 then ba=false else ba=true end if%>
	<%writehead_sub "退订管理", "return_view.asp", ba%>
	<%if headtype=3 then ba=false else ba=true end if%>
	<%writehead_sub "系统设置", "options.asp", ba%>
	<td width=300></td>
</tr>
<%
	end function
	
	function writehead_sub( name, alink, ba )
%>
		<%if ba=true then  %><td class=border_nosel align=center width=100><a href="<%=alink%>"><%=name%></a></td><%end if%>
		<%if ba=false then %><td class=border_cusel align=center width=100><%=name%></td><%end if%>
<%
	end function
%>