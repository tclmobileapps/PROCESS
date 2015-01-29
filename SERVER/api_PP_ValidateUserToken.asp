<!--#include file="admin/aspJSON1.16.asp"-->
<!--#include file="admin/General.asp"-->
<!--#include file="admin/PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim jcLastActionDate, jcLastActionTime
Dim j1, j2
Dim jnCount
Dim jnTimeDiffInSeconds
j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ValidateUserToken")

if not jbIsError then
	if not ValidateUserToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "User credentials need to be revalidated"
	end if
end if
oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if jbIsError then
	oJSON.data("cInfo") = "Error: " & jcErrorMessage
else
	oJSON.data("cInfo") = "Token authenticated."
end if
response.write oJSON.JSONoutput()
%>