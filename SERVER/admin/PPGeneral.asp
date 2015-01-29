<%
sub ClearDebugTables
	ExecSQL "DELETE FROM T_00"
end sub

function CreateJSON_Func()
	CreateJSON_Func = false
	Dim jConn, jRs, jSQL
	Dim jFunc, jnFunc
	jnFunc = 0
	jFunc = "{ " & MakeJSONStr("funcs") & ":" & vbcrlf & _
		JSONIndent(1) & "[" & vbcrlf
	set jConn = Connect2DB()
	jSQL = "SELECT * FROM T_PP_FUNC WHERE cIsActive='Y' ORDER BY nDisplayOrder, cFunc"
	set jRs = OpenRs(jConn)
	jRs.open jSQL
	if not IsNullRs(jRs) then
		jRs.movefirst
		while not jRs.eof
			jnFunc = jnFunc + 1
			if jnFunc > 1 then
				jFunc = jFunc & "," & vbcrlf
			end if
			jFunc = jFunc & JSONIndent(2) & "{" & vbcrlf
			jFunc = jFunc & JSONIndent(3) & MakeJSONKeyValuePairX("cFunction", GetX(jRs, "cFunc")) & "," & vbcrlf
			jFunc = jFunc & JSONIndent(3) & MakeJSONKeyValuePairX("cName", GetX(jRs, "cName")) & "," & vbcrlf
			jFunc = jFunc & JSONIndent(3) & MakeJSONKeyValuePairX("nProducts", GetCount("T_PP_PROD", "cFunc='" & GetX(jRs, "cFunc") & "' AND cIsActive='Y'")) & vbcrlf
			jFunc = jFunc & JSONIndent(2) & "}" 
			jRs.movenext
		wend
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
	jFunc = jFunc & vbcrlf & JSONIndent(1) & "]" & vbcrlf & "}"
	response.write jFunc & "</br>"
	CreateTextFile "../json/m_function.json", jFunc
	CreateJSON_Func = true
end function

function GetParamDelim()
	GetParamDelim = "~~~~"
end function

function GetPostParam(byval pcParamName)
	Dim jcParamName, jX
	jcParamName = "txtParam" & pcParamName
	jX = trim("" & request.form(jcParamName))
	if len(jX) = 0 then
		jX = trim("" & request(jcParamName))
	end if
	GetPostParam = jX
end function

function InitJSON(pcApiName)
	Dim o
	set o = new aspJSON
	o.data("bIsError") = true
	o.data("cErrorMessage") = "Error in API: " & pcApiName
	o.data("cInfo") = ""
	set InitJSON = o
end function

function ValidateToken(pcUser, pcToken)
	ValidateToken = false
	if GetCount("T_PP_LOGIN_ATTEMPT", "cUser='" & pcUser & "' AND cToken='" & pcToken & "' AND cStatus='A'") = 1 then
		ValidateToken = true
	end if
end function

function ValidateUserToken(pcUser, pcToken)
	ValidateUserToken = false
	Dim jcLastActionDate, jcLastActionTime
	Dim jcSysDate, jcSysTime
	jcLastActionDate = "00000000"
	jcLastActionTime = "000000"
	GetSysDateTime jcSysDate, jcSysTime
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jRs.open "SELECT * FROM T_PP_USER_LOGIN_ATTEMPT WHERE cUser='" & pcUser & "' AND cToken='" & pcToken & "' AND cStatus='A'"
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			jcLastActionDate = GetX(jRs, "cLastActionDate")
			jcLastActionTime = GetX(jRs, "cLastActionTime")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
	jnTimeDiffInSeconds = GetTimeDiffInSeconds(jcLastActionDate, jcLastActionTime, jcSysDate, jcSysTime)
	if jnTimeDiffInSeconds <= (15*60) then
		jSQL = "UPDATE T_PP_USER_LOGIN_ATTEMPT SET cLastActionDate='" & jcSysDate & "', cLastActionTime='" & jcSysTime & "'" & _
			" WHERE cUser='" & pcUser & "' AND cToken='" & pcToken & "' AND cStatus='A'"
		ExecSQL jSQL
		ValidateUserToken = true
	end if		
end function

function GetFolderPath(pcProcess)
	GetFolderPath = "c:/inetpub/wwwroot/process/data/" & pcProcess
end function
%>