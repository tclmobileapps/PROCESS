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
Dim jaProcess, jaVertical, jaProduct, jaFunc, jaRole, jaDisplayOrder, jaIsActive
Dim jcProcess, jcVertical, jcProduct, jcFunc, jcRole, jnDisplayOrder, jcIsActive
Dim ji, jnIndex, jj
Dim jnDoneProcessMapCount

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
	jaVertical = split(jcParam(2), GetParamDelim())
	jaProduct = split(jcParam(3), GetParamDelim())
	jaFunc = split(jcParam(4), GetParamDelim())
	jaRole = split(jcParam(5), GetParamDelim())
	jaDisplayOrder = split(jcParam(6), GetParamDelim())
	jaIsActive = split(jcParam(7), GetParamDelim())
	jnIndex = LBound(jaProcess)
	jnDoneProcessMapCount=0
	for ji = 1 to jnInRecs
		jcProcess = jaProcess(jnIndex)
		jcVertical = jaVertical(jnIndex)
		jcProduct = jaProduct(jnIndex)
		jcFunc = jaFunc(jnIndex)
		jcRole = jaRole(jnIndex)
		jnDisplayOrder = cLng(jaDisplayOrder(jnIndex))
		jcIsActive = jaIsActive(jnIndex)

		jcWhere = "cProcess='" & jcProcess & "' AND cVertical='" & jcVertical & "' AND cProduct='" & jcProduct & "' AND cFunc='" & jcFunc & "' AND cRole='" & jcRole & "'"
		if GetCount("T_PP_PROCESSMAP", jcWhere) = 1 then
			jSQL = "UPDATE T_PP_PROCESSMAP SET " & _
				" nDisplayOrder=" & jnDisplayOrder & _
				", cIsActive=" & MakeUpdX(jcIsActive) & _
				" WHERE cProcess='" & jcProcess & "' AND cVertical='" & jcVertical & "' AND cProduct='" & jcProduct & "' AND cFunc='" & jcFunc & "' AND cRole='" & jcRole & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_PROCESSMAP(cProcess, cVertical, cProduct" & _
				", cFunc, cRole" & _
				", nDisplayOrder, cIsActive" & _
				") VALUES (" & _
				MakeInsX(jcProcess) & "," & MakeInsX(jcVertical) & "," & MakeInsX(jcProduct) & _
				", " & MakeInsX(jcFunc) & "," & MakeInsX(jcRole) & "," & MakeInsL(jnDisplayOrder) & "," & MakeInsX(jcIsActive) & _
				")"
			ExecSQL jSQL
		end if
		jnIndex = jnIndex + 1
		jnDoneProcessMapCount = jnDoneProcessMapCount + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneProcessMapCount & " Process-Map record(s)."
end if
response.write oJSON.JSONoutput()
%>
