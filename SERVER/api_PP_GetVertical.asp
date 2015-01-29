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

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("GetFunc")

if not jbIsError then
	if not ValidateUserToken(j1, j2) then
		jbIsError = true
		jcErrorMessage	= "User credentials need to be re-verified."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_PP_VERTICAL WHERE cIsActive='Y' ORDER BY cName"
	jRs.open jSQL
	oJSON.data.add "aVerticals", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			with oJSON.data("aVerticals")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "cVertical", GetX(jRs, "cVertical")
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
	oJSON.data("cInfo") = "Number of Verticals: " & jnCount & "." 
	oJSON.data("nVerticals") = jnCount
end if
response.write oJSON.JSONoutput()
%>