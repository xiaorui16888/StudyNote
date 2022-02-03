<%
	class class_return
		public m_Connect, m_rs, m_isconnect
	
		public function OpenConnect
		
			Set m_rs=Server.CreateObject("ADODB.Recordset")
	
	        set m_Connect = Server.CreateObject("ADODB.Connection")
            m_Connect.Open "Provider = Microsoft.Jet.OLEDB.4.0;Data Source = "_
                &server.mappath("data/#return.mdb")
                
			m_isconnect=true		
		end function 
		
		public function CloseConnect
			m_connect.Close
			set m_connect=nothing
			set m_rs=nothing
		end function
		
		public function OutputList
			on error resume next
			
			m_rs.Open "select email from return",m_Connect,adOpenKeyset,adLockOptimistic
			while not m_rs.EOF 
				Response.Write m_rs("email")&chr(13)&chr(10)
				m_rs.MoveNext	
			wend
			m_rs.Close
		end function
		
		public function DeleteEmails
			on error resume next
			
			m_Connect.Execute("delete from return")
			if err.number = 0 then	
				DeleteEmails=true
			else
				DeleteEmails=false
				Response.Write "…æ≥˝ ß∞‹£∫"&err.Description
			end if	
		end function
		
		public function InsertEmail( aemail )
			on error resume next
			
			dim cmd
			set cmd = Server.CreateObject("ADODB.Command")
			cmd.CommandText = "select * from return where email=?;"
			
			dim p1
	        Set p1 = cmd.CreateParameter ("@P1", adVarChar, 1, 256, aemail )
			cmd.Parameters.Append p1
			cmd.CommandType=adCmdText
			
			cmd.ActiveConnection = m_Connect
			m_rs.Open cmd, ,adOpenKeyset,adLockOptimistic
			
			if m_rs.RecordCount>0 then
				m_rs("n")=m_rs("n")+1
				m_rs("lasttime")=Now()
				m_rs.Update
			else 
				m_rs.AddNew
				m_rs("email")=aemail
				m_rs("n")=1
				m_rs("lasttime")=Now()
				m_rs.Update
			end if
			m_rs.Close
			Response.Write "<p><b>" & aemail &"</b></p>"&chr(13)&chr(10)
			
			' ±£¥Ê ß∞‹
			if Err.number<>0 then
				Response.Write "ÕÀ∂©±£¥Ê ß∞‹£∫" & Err.Description 
			else	
			'±£¥Ê≥…π¶
				dim outtext
			
				dim fs,f
				set fs = Server.CreateObject("Scripting.FileSystemObject")
				set f = fs.OpenTextFile(Server.MapPath("return_output.txt"))
							
				Response.Write f.ReadAll
			
				f.Close
			end if
		end function
		
		public function execsql( sqltext )
            on error resume next
            m_Connect.Execute sqltext
		end function	
		
		public function getrecords( sqlcmd, byref ars )
		    sqlcmd.ActiveConnection = m_Connect
		    ars.Open sqlcmd, ,adOpenKeyset, adLockOptimistic
		end function
		
	end class
%>
