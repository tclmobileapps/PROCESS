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
Dim jnCount, jnFileCount
Dim jcProcess

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jcProcess = GetPostParam("cProcess")

jnCount = 0
jnFileCount = 0

GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("GetProcessData")

oJSON.data("nRow") = 0
oJSON.data("nFile") = 0

if not jbIsError then
	if not ValidateUserToken(j1, j2) then
		jbIsError = true
		jcErrorMessage	= "User credentials need to be re-verified."
	end if
end if
if not jbIsError then
	set jConn = Connect2DB()
	
	set jRs = OpenRs(jConn)
	jSQL = "sELECT * FROM T_PP_PROCESS WHERE cProcess='" & jcProcess & "'"
	jRs.open jSQL
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			oJSON.data("cProcess") = GetX(jRs, "cProcess")
			oJSON.data("cProcessName") = GetX(jRs, "cName")
			oJSON.data("cMajor") = GetX(jRs, "cMajor")
			oJSON.data("cMinor") = GetX(jRs, "cMinor")
		end if
	end if
	CloseRs(jRs)

	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_PP_PROCESS_FILE WHERE cProcess='" & jcProcess & "'" & _
		" ORDER BY cToken"
	jRs.open jSQL
	oJSON.data.add "aFile", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			with oJSON.data("aFile")
				.Add jnFileCount, oJSON.Collection()
				with .item(jnFileCount)
					.Add "cToken", GetX(jRs, "cToken")
					.Add "cFileName", GetX(jRs, "cFileName")
					.Add "cDisplayText", GetX(jRs, "cDisplayText")
				end with
			end with
			jnFileCount = jnFileCount + 1
			jRs.movenext
		wend
	end if
	CloseRs(jRs)

	set jRs = OpenRs(jConn)
	jSQL = "SELECT * FROM T_PP_PROCESS_DATA WHERE cProcess='" & jcProcess & "'" & _
		" ORDER BY nRow"
	jRs.open jSQL
	oJSON.data.add "aRow", oJSON.Collection()
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			with oJSON.data("aRow")
				.Add jnCount, oJSON.Collection()
				with .item(jnCount)
					.Add "nRow", GetX(jRs, "nRow")
					.Add "cSrl", GetX(jRs, "cSrl")
					.Add "cStep", GetX(jRs, "cStep")
					.Add "cControl", GetX(jRs, "cControl")
					.Add "cResponsibility", GetX(jRs, "cResponsibility")
					.Add "cMetrics", GetX(jRs, "cMetrics")
					.Add "nMergeRows", GetN(jRs, "nMergeRows")
					.Add "cIsMergeStart", GetX(jRs, "cIsMergeStart")
					.Add "cIsMergeEnd", GetX(jRs, "cIsMergeEnd")
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
	oJSON.data("cInfo") = "Number of Rows: " & jnCount & ". Number of files: " & jnFileCount 
	oJSON.data("nRow") = jnCount
	oJSON.data("nFile") = jnFileCount
end if
response.write oJSON.JSONoutput()
%>