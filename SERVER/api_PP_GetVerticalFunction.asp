<!--#include file="admin/aspJSON1.16.asp"-->
<!--#include file="admin/General.asp"-->
<!--#include file="admin/PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim j1, j2
Dim jnCount
Dim jcVertical

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcVertical = GetPostParam("cVertical")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("GetVerticalFunction")

if not jbIsError then
	if not ValidateUserToken(j1, j2) then
		jbIsError = true
		jcErrorMessage	= "User credentials need to be re-verified."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT F.cName, F.cFunc FROM T_PP_FUNC F, T_PP_PROCESSMAP PM" & _
		" WHERE PM.cVertical='" & jcVertical & "' AND PM.cIsActive='Y'" & _
		" AND F.cFunc=PM.cFunc" & _
		" AND F.cIsActive='Y'" & _
		" GROUP BY F.cName, F.cFunc" & _
		" ORDER BY F.cName, F.cFunc"
	jRs.open jSQL
	oJSON.data.add "aFunctions", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			with oJSON.data("aFunctions")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cFunction", GetX(jRs, "cFunc")
					.Add "cName", GetX(jRs, "cName")
				end with
			end with		
			jnCount = jnCount + 1		
			
			jRs.movenext
		wend
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Number of Functions: " & jnCount & "." 
	oJSON.data("nFunctions") = jnCount
end if
response.write oJSON.JSONoutput()
%>