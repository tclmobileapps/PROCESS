<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = 0 %>
<% Response.Buffer = TRUE %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError, jcErrorMessage, jcWhere
Dim jcSysDate, jcSysTime
Dim j1, j2
Dim jcProcess, jcToken, jnFileSize
Dim UploadRequest
Dim jnByteCount, jcBinaryData, jnLenB
Dim ji
Dim jcTemp, jcChar
Dim jcNewLine, jnPos
Dim jcBoundary
Dim jcQS
Dim jcVarType
Dim jcFileName, jcFolderName

jcQS = request.QueryString
ClearDebugTables
j1 = request.QueryString("txtParam1")
j2 = request.QueryString("txtParam2")
jcProcess = request.QueryString("txtParamcProcess")
jcToken = request.QueryString("txtParamcToken")
jnByteCount = Request.TotalBytes
jcBinaryData = Request.BinaryRead(jnByteCount)
'jcNewLine = chrB(13) & chrB(10)
'jnPos = inStrB(1, jcBinaryData, jcNewLine)
'jcBoundary = midB(jcBinaryData, 1, jnPos - 1)
'jcVarType = vartype(jcBinaryData)
jnLenB = lenB(jcBinaryData)
jSQL = "INSERT INTO T_00(c1, c2, c3, c4, c5, c6) VALUES(" & _
	MakeInsX(j1) & "," & MakeInsX(j2) & "," & MakeInsX(jcProcess) & "," & MakeInsX(jcToken) & "," & MakeInsX(jnByteCount & "/" & jnLenB) & _
		"," & MakeInsX("DELME") & _
	")"
ExecSQL jSQL

Set UploadRequest = Nothing

Dim objFSO, objFile
Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
jcFolderName = GetFolderPath(jcProcess)
jcFileName = jcFolderName & "/" & jcToken
if objFSO.FolderExists(jcFolderName) then
else
	objFSO.CreateFolder(jcFolderName)
end if
jSQL = "INSERT INTO T_00(c1) VALUES(" & _
	MakeInsX(jcFolderName) & _
	")"
ExecSQL jSQL
Set objFile = objFSO.CreateTextFile(jcFileName, true, true)
objFile.write(jcBinaryData)
objFile.Close
Set objFile=Nothing
Set objFSO = nothing
response.write "Done with token " & jcToken
%>
