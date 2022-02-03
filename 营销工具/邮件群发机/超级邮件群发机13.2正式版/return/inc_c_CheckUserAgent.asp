<%
class CheckUserAgent
	public vOs
	public vSoft

	public function execute(strUA)
	  vOs=trim(getos(cwin(strUA)))
	  vSoft=trim(getsoft(strUA))


	  if vOs="" and instr(vSoft,"Konqueror") then vOs="Linux"
	  if instr(vSoft,"Mozilla") and instr(strUA,"compatible") then vSoft=""
	  select case vOs
	  case "Windows NT 5.0"
	    vOs = "Windows 2000"
	  case "Windows NT 5.1"
	    vOs = "Windows XP"
	  case "Windows NT 5.2"
	    vOs = "Windows Server 2003"
	  case else
	    vOs = vOs
	  end select
	end function
	
	private function getos(strUA)
	  dim regEx ,match,matches,maxlong
	  getos=""
	  maxlong=0
	  Set regEx = New RegExp
	  regEx.Pattern = "(Windows|Mac |Mac_|Win|PPC|Linux|unix|SunOS|BSD)[^;\(\)\[]{0,20}"
	  regEx.IgnoreCase = True
	  regEx.Global = True
	  Set Matches = regEx.Execute(strUA)
	  For Each Match in Matches
	    if match.length>maxlong then
			maxlong=match.length
			getos=match.value
		end if
	  Next
	end function
	
	private function getsoft(strUA)
	  dim regEx ,match,matches,maxlong
	  getsoft=""
	  Set regEx = New RegExp
	  regEx.Pattern = "(Konqueror|Opera|Safar|Firebird|NetCaptor|MSN |Netscape|MSIE|MyIE|OmniWeb|AOL|WebTV|iCab|Mozilla)[\d\/]?\d*\.?\d*\.*\d*[^;\(\)\[]*"
	  regEx.IgnoreCase = True
	  regEx.Global = True
	  Set Matches = regEx.Execute(strUA)
	  For Each Match in Matches
		if instr(getsoft,"Mozilla") then
			getsoft = match.value
		else
			getsoft = getsoft & "," & match.value
		end if
	  Next
	  getsoft=replace(getsoft,"/"," ")
	end function

	private function cwin(strUA)
	  dim regEx
	  Set regEx = New RegExp
	  regEx.Pattern = "Win\s?(\d+|NT)"
	  regEx.IgnoreCase = True
	  regEx.Global = True
	  cwin=regEx.Replace (strUA,"Windows $1")
	end function

end class
%>