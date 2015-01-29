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
Dim jcProcess, jcVersionMode, jnInRecs, jnTokens
ReDim jcParam(10), jcTokenParam(4)
Dim jaSrl, jaStep, jaControl, jaResponsibility, jaMetrics, jaMergeRows, jaIsMergeStart, jaIsMergeEnd
Dim jcSrl, jcStep, jcControl, jcResponsibility, jcMetrics, jnMergeRows, jcIsMergeStart, jcIsMergeEnd
Dim jaToken, jaFileName, jaDisplayText
Dim jcToken, jcFileName, jcDisplayText
Dim ji, jnIndex, jj
Dim jnDoneCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcProcess = GetPostParam("cProcess")
jcVersionMode = GetPostParam("cVersionMode")
jnInRecs = cLng(GetPostParam("nInRecs"))
jnTokens = cLng(GetPostParam("nTokens"))
for ji = 1 to 8
	jcParam(ji) = GetPostParam("P" & ji)
next
for ji = 1 to 3
	jcTokenParam(ji) = GetPostParam("T" & ji)
next 
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("PutProcessData")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if
if not jbIsError then
	if GetCount("T_PP_PROCESS", "cProcess='" & jcProcess & "'") <> 1 then
		jbIsError = true
		jcErrorMessage = "Invalid process code. Please try again."
	end if
end if
if not jbIsError then
	jSQL = "UPDATE T_PP_PROCESS SET cIsActive='N' WHERE cProcess='" & jcProcess & "'"
	ExecSQL jSQL
	jSQL = "DELETE FROM T_PP_PROCESS_FILE WHERE cProcess='" & jcProcess & "'"
	ExecSQL jSQL
	jSQL = "DELETE FROM T_PP_PROCESS_DATA WHERE cProcess='" & jcProcess & "'"
	ExecSQL jSQL
end if
if not jbIsError then
	jaSrl = split(jcParam(1), GetParamDelim())
	jaStep = split(jcParam(2), GetParamDelim())
	jaControl = split(jcParam(3), GetParamDelim())
	jaResponsibility = split(jcParam(4), GetParamDelim())
	jaMetrics = split(jcParam(5), GetParamDelim())
	jaMergeRows = split(jcParam(6), GetParamDelim())
	jaIsMergeStart = split(jcParam(7), GetParamDelim())
	jaIsMergeEnd = split(jcParam(8), GetParamDelim())

	jaToken = split(jcTokenParam(1), GetParamDelim())
	jaFileName = split(jcTokenParam(2), GetParamDelim())
	jaDisplayText	 = split(jcTokenParam(3), GetParamDelim())

	jnIndex = LBound(jaSrl)
	jnDoneCount=0
	for ji = 1 to jnInRecs
		jcSrl = jaSrl(jnIndex)
		jcStep = jaStep(jnIndex)
		jcControl = jaControl(jnIndex)
		jcResponsibility = jaResponsibility(jnIndex)
		jcMetrics = jaMetrics(jnIndex)
		jnMergeRows = cLng(jaMergeRows(jnIndex))
		jcIsMergeStart = jaIsMergeStart(jnIndex)
		jcIsMergeEnd = jaIsMergeEnd(jnIndex)
		jSQL = "INSERT INTO T_PP_PROCESS_DATA(cProcess, nRow" & _
			", cSrl, cStep, cControl" & _
			", cResponsibility, cMetrics" & _
			", nMergeRows, cIsMergeStart, cIsMergeEnd" & _
			") VALUES (" & _
			MakeInsX(jcProcess) & "," & ji & _
			"," & MakeInsX(jcSrl) & "," & MakeInsX(jcStep) & "," & MakeInsX(jcControl) & _
			"," & MakeInsX(jcResponsibility) & "," & MakeInsX(jcMetrics) & _
			"," & jnMergeRows & "," & MakeInsX(jcIsMergeStart) & "," & MakeInsX(jcIsMergeEnd) & _
			")"
		ExecSQL jSQL
		jnIndex = jnIndex + 1
		jnDoneCount = jnDoneCount + 1
	next

	jnIndex = LBound(jaToken)
	for ji = 1 to jnTokens
		jcToken = jaToken(jnIndex)
		jcFileName = jaFileName(jnIndex)
		jcDisplayText = jaDisplayText(jnIndex)
		jSQL = "INSERT INTO T_PP_PROCESS_FILE(cProcess, cToken" & _
			", cFileName, cDisplayText" & _
			") VALUES (" & _
			MakeInsX(jcProcess) & "," & MakeInsX(jcToken) & _
			"," & MakeInsX(jcFileName) & "," & MakeInsX(jcDisplayText) & _
			")"
		ExecSQL jSQL
		jnIndex = jnIndex + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneCount & " Process Data record(s)."
end if
response.write oJSON.JSONoutput()
%>
