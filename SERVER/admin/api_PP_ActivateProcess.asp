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
Dim jcProcess, jcVersionMode

Dim jcMajor, jcMinor

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcProcess = GetPostParam("cProcess")
jcVersionMode = GetPostParam("cVersionMode")

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("ActivateProcess")

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
	jcMajor = "0"
	jcMinor = "0"
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jSQL = "SELECT cMajor, cMinor FROM T_PP_PROCESS WHERE cProcess='" & jcProcess & "'"
	jRs.open jSQL
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			jcMajor = GetX(jRs, "cMajor")
			jcMinor = GetX(jRs, "cMinor")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
	if jcVersionMode = "SAME" then
		jSQL = "UPDATE T_PP_PROCESS SET cIsActive='Y' WHERE cProcess='" & jcProcess & "'"
		ExecSQL jSQL
	end if
	if jcVersionMode = "MAJOR" then
		jcMinor = "0"
		jcMajor = "" & (cLng(jcMajor) + 1)
		jSQL = "UPDATE T_PP_PROCESS SET cMajor='" & jcMajor & "', cMinor='" & jcMinor & "', cIsActive='Y' WHERE cProcess='" & jcProcess & "'"
		ExecSQL jSQL
	end if
	if jcVersionMode = "MINOR" then
		jcMinor = "" & (cLng(jcMinor) + 1)
		jSQL = "UPDATE T_PP_PROCESS SET cMajor='" & jcMajor & "', cMinor='" & jcMinor & "',cIsActive='Y' WHERE cProcess='" & jcProcess & "'"
		ExecSQL jSQL
	end if
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Process activated, version is " & jcMajor & "." & jcMinor
end if
response.write oJSON.JSONoutput()
%>
