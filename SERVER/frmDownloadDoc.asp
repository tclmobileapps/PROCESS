<%
Dim jcProcess, jcFilePath, jcFileName, jcDiskFileName
jcProcess = request("txtProcess")
jcFileName = request("txtFileName")
jcDiskFileName = request("txtDiskFileName")
jcFilePath = "/" & Split(Request.ServerVariables("SCRIPT_NAME"), "/")(1) & "/data/" & jcProcess & "/" & jcDiskFileName
jcFilePath = "D:\TCL\APPS\PROCESS\data\" & jcDiskFileName
Dim jx
jx = Server.MapPath("data\" & jcProcess)
jcFilePath = jx & "\" & jcDiskFileName
Response.Buffer = False
Dim objStream
Set objStream = Server.CreateObject("ADODB.Stream")
objStream.Type = 1 'adTypeBinary
objStream.Open
objStream.LoadFromFile(jcFilePath)
Response.ContentType = "application/x-unknown"
Response.Addheader "Content-Disposition", "attachment; filename=" & jcFileName
'Response.Addheader "Content-Disposition", "attachment; filename=" & jx
Response.BinaryWrite objStream.Read
objStream.Close
Set objStream = Nothing
%>
