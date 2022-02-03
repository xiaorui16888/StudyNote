<%
dim con_return
set con_return = Server.CreateObject("ADODB.Connection")
con_return.Open "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = "_
&server.mappath("data/#return.mdb")
%>