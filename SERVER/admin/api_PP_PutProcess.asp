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
Dim jaProcess, jaName, jaShortName, jaDisplayOrder, jaIsActive, jaMajor, jaMinor
Dim jcProcess, jcName, jcShortName, jnDisplayOrder, jcIsActive, jcMajor, jcMinor
Dim ji, jnIndex, jj
Dim jnDoneProcessCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnInRecs = cLng(GetPostParam("nInRecs"))
for ji = 1 to 7
	jcParam(ji) = GetPostParam("P" & ji)
next
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("PutProcess")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if

if not jbIsError then
	jaProcess = split(jcParam(1), GetParamDelim())
	jaName = split(jcParam(2), GetParamDelim())
	jaShortName = split(jcParam(3), GetParamDelim())
	jaDisplayOrder = split(jcParam(4), GetParamDelim())
	jaIsActive = split(jcParam(5), GetParamDelim())
	jaMajor = split(jcParam(6), GetParamDelim())
	jaMinor = split(jcParam(7), GetParamDelim())
	jnIndex = LBound(jaProcess)
	jnDoneProcessCount=0
	for ji = 1 to jnInRecs
		jcProcess = jaProcess(jnIndex)
		jcName = jaName(jnIndex)
		jcShortName = jaShortName(jnIndex)
		jnDisplayOrder = cLng(jaDisplayOrder(jnIndex))
		jcIsActive = jaIsActive(jnIndex)
		jcMajor = jaMajor(jnIndex)
		jcMinor = jaMinor(jnIndex)

		if GetCount("T_PP_PROCESS", "cProcess='" & jcProcess & "'") = 1 then
			jSQL = "UPDATE T_PP_PROCESS SET cName=" & MakeUpdX(jcName) & _
				", cShortName=" & MakeUpdX(jcShortName) & _
				", nDisplayOrder=" & jnDisplayOrder & _
				", cIsActive=" & MakeUpdX(jcIsActive) & _
				", cMajor=" & MakeUpdX(jcMajor) & _
				", cMinor=" & MakeUpdX(jcMinor) & _
				" WHERE cProcess='" & jcProcess & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_PROCESS(cProcess, cName" & _
				", cShortName, nDisplayOrder, cIsActive" & _
				", cMajor, cMinor" & _
				") VALUES (" & _
				MakeInsX(jcProcess) & "," & MakeInsX(jcName) & _
				", " & MakeInsX(jcShortName) & "," & MakeInsL(jnDisplayOrder) & "," & MakeInsX(jcIsActive) & _
				", " & MakeInsX(jcMajor) & ", " & MakeInsX(jcMinor) & _
				")"
			ExecSQL jSQL
		end if

		jnIndex = jnIndex + 1
		jnDoneProcessCount = jnDoneProcessCount + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneProcessCount & " Process record(s)."
end if
response.write oJSON.JSONoutput()
%>
