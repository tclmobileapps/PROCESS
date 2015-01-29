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
Dim jaFunc, jaName, jaShortName, jaDisplayOrder, jaIsActive
Dim jcFunc, jcName, jcShortName, jnDisplayOrder, jcIsActive
Dim ji, jnIndex, jj
Dim jnDoneFuncCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnInRecs = cLng(GetPostParam("nInRecs"))
for ji = 1 to 8
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
	jaFunc = split(jcParam(1), GetParamDelim())
	jaName = split(jcParam(2), GetParamDelim())
	jaShortName = split(jcParam(3), GetParamDelim())
	jaDisplayOrder = split(jcParam(4), GetParamDelim())
	jaIsActive = split(jcParam(5), GetParamDelim())
	jnIndex = LBound(jaFunc)
	jnDoneFuncCount=0
	for ji = 1 to jnInRecs
		jcFunc = jaFunc(jnIndex)
		jcName = jaName(jnIndex)
		jcShortName = jaShortName(jnIndex)
		jnDisplayOrder = cLng(jaDisplayOrder(jnIndex))
		jcIsActive = jaIsActive(jnIndex)

		if GetCount("T_PP_FUNC", "cFunc='" & jcFunc & "'") = 1 then
			jSQL = "UPDATE T_PP_FUNC SET cName=" & MakeUpdX(jcName) & _
				", cShortName=" & MakeUpdX(jcShortName) & _
				", nDisplayOrder=" & jnDisplayOrder & _
				", cIsActive=" & MakeUpdX(jcIsActive) & _
				" WHERE cFunc='" & jcFunc & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_FUNC(cFunc, cName" & _
				", cShortName, nDisplayOrder, cIsActive" & _
				") VALUES (" & _
				MakeInsX(jcFunc) & "," & MakeInsX(jcName) & _
				", " & MakeInsX(jcShortName) & "," & MakeInsL(jnDisplayOrder) & "," & MakeInsX(jcIsActive) & _
				")"
			ExecSQL jSQL
		end if

		jnIndex = jnIndex + 1
		jnDoneFuncCount = jnDoneFuncCount + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneFuncCount & " Function record(s)."
end if
response.write oJSON.JSONoutput()
%>
