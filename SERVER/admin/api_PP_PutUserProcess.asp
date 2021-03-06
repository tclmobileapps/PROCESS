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
Dim jaUser, jaProcess, jaIsActive
Dim jcUser, jcProcess, jcIsActive
Dim ji, jnIndex, jj
Dim jnDoneUserProcessCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnInRecs = cLng(GetPostParam("nInRecs"))
for ji = 1 to 3
	jcParam(ji) = GetPostParam("P" & ji)
next
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("PutFunc")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if

if not jbIsError then
	jaUser = split(jcParam(1), GetParamDelim())
	jaProcess = split(jcParam(2), GetParamDelim())
	jaIsActive = split(jcParam(3), GetParamDelim())
	jnIndex = LBound(jaUser)
	jnDoneUserProcessCount=0
	for ji = 1 to jnInRecs
		jcUser = jaUser(jnIndex)
		jcProcess = jaProcess(jnIndex)
		jcIsActive = jaIsActive(jnIndex)

		if GetCount("T_PP_USER_PROCESS", "cUser='" & jcUser & "' AND cProcess='" & jcProcess & "'") = 1 then
			jSQL = "UPDATE T_PP_USER_PROCESS SET " & _
				" cIsActive=" & MakeUpdX(jcIsActive) & _
				" WHERE cUser='" & jcUser & "' AND cProcess='" & jcProcess & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_USER_PROCESS(cUser, cProcess" & _
				", cIsActive" & _
				") VALUES (" & _
				MakeInsX(jcUser) & "," & MakeInsX(jcProcess) & _
				", " & MakeInsX(jcIsActive) & _
				")"
			ExecSQL jSQL
		end if

		jnIndex = jnIndex + 1
		jnDoneUserProcessCount = jnDoneUserProcessCount + 1
	next
	jSQL = "DELETE FROM T_PP_USER_PROCESS WHERE cIsActive <> 'Y'"
	ExecSQL jSQL
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneUserProcessCount & " User Process record(s)."
end if
response.write oJSON.JSONoutput()
%>
