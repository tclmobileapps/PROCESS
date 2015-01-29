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
Dim jcVertical, jcFunction

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcVertical = GetPostParam("cVertical")
jcFunction = GetPostParam("cFunction")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("GetVerticalFunctionRole")

if not jbIsError then
	if not ValidateUserToken(j1, j2) then
		jbIsError = true
		jcErrorMessage	= "User credentials need to be re-verified."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT R.cName, R.cRole FROM T_PP_ROLE R, T_PP_FUNC F, T_PP_PROCESSMAP PM" & _
		" WHERE PM.cVertical='" & jcVertical & "' AND PM.cFunc='" & jcFunction & "' AND PM.cIsActive='Y'" & _
		" AND F.cFunc=PM.cFunc" & _
		" AND F.cIsActive='Y'" & _
		" AND R.cFunc=F.cFunc AND R.cIsActive='Y'" & _
		" GROUP BY R.cName, R.cRole" & _
		" ORDER BY R.cName, R.cRole"
	'oJSON.data("cSQL") = jSQL
	'jSQL = "SELECT * FROM T_PP_ROLE"
	jRs.open jSQL
	
	oJSON.data.add "aRoles", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			with oJSON.data("aRoles")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cRole", GetX(jRs, "cRole")
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
	oJSON.data("cInfo") = "Number of Roles: " & jnCount & "." 
	oJSON.data("nRoles") = jnCount
end if
response.write oJSON.JSONoutput()
%>