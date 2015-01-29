<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim j1, j2
Dim jnInRecs
ReDim jcParam(10)
Dim jaUser, jaName, jaRole, jaIsActive
Dim jcUser, jcName, jcRole, jcIsActive
Dim ji, jnIndex, jj
Dim jnDoneUserCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnInRecs = cLng(GetPostParam("nInRecs"))
for ji = 1 to 4
	jcParam(ji) = GetPostParam("P" & ji)
next
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("PutUser")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if

if not jbIsError then
	jaUser = split(jcParam(1), GetParamDelim())
	jaName = split(jcParam(2), GetParamDelim())
	jaRole = split(jcParam(3), GetParamDelim())
	jaIsActive = split(jcParam(4), GetParamDelim())
	jnIndex = LBound(jaUser)
	jnDoneUserCount=0
	for ji = 1 to jnInRecs
		jcUser = jaUser(jnIndex)
		jcName = jaName(jnIndex)
		jcRole = jaRole(jnIndex)
		jcIsActive = jaIsActive(jnIndex)

		if GetCount("T_PP_USER", "cUser='" & jcUser & "'") = 1 then
			jSQL = "UPDATE T_PP_USER SET cName=" & MakeUpdX(jcName) & _
				", cRole=" & MakeUpdX(jcRole) & _
				", cIsActive=" & MakeUpdX(jcIsActive) & _
				" WHERE cUser='" & jcUser & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_USER(cUser, cName" & _
				", cRole, cIsActive" & _
				") VALUES (" & _
				MakeInsX(jcUser	) & "," & MakeInsX(jcName) & _
				", " & MakeInsX(jcRole) & "," & MakeInsX(jcIsActive) & _
				")"
			ExecSQL jSQL
		end if

		jnIndex = jnIndex + 1
		jnDoneUserCount = jnDoneUserCount + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneUserCount & " User record(s)."
end if
response.write oJSON.JSONoutput()
%>
