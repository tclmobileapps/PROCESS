<!--#include file="aspJSON1.16.asp"-->
<!--#include file="General.asp"-->
<!--#include file="PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
<%
Dim jConn, jRs, jSQL, oJSON, jbIsError
Dim jcSysDate, jcSysTime
Dim jcUser, jcPassword
Dim jcToken, jcWasSuccessful, jcIsActive, jcIsAdmin, jcName, jcLastLoginDate, jcLastLoginTime, jcStatus, jcRemarks, jcRole, jcIsProcessOwner

jcUser = GetPostParam("User")
jcPassword = GetPostParam("Password")
jcUser = Convert2Key(jcUser, true)
jcToken = ""
jcWasSuccessful = "N"
jcIsAdmin = "N"
jcIsActive = "N"
jcName = ""
jcLastLoginDate = ""
jcLastLoginTime = ""
jcStatus = "X"
jcRemarks = ""
jcRole = "E" 'End User
jcIsProcessOwner = "N"
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
set oJSON = InitJSON("DoLogin")
jcName = jcUser
if not jbIsError then
	if GetCount("T_PP_USER", "cUser='" & jcUser & "'") = 1 then
		jcRole = GetSingleX("T_PP_USER", "cRole", "cUser='" & jcUser & "'")
	end if
end if

if not jbIsError then
	jcToken = GetGUID()
	jcWasSuccessful = "Y"
	jcStatus = "A"
	jcIsActive = "Y"
	if jcRole = "A" then
		jcIsAdmin = "Y"
		jcIsProcessOwner = "Y"
	end if
	if jcRole = "P" then
		jcIsProcessOwner = "Y"
	end if
	jcRemarks = ""
	set jConn = Connect2DB()
	set jRs = OpenRs(jConn)
	jRs.open "SELECT * FROM T_PP_LOGIN_ATTEMPT WHERE cUser='" & jcUser & "' AND cStatus='A'" & _
		" ORDER BY cDate DESC, cTime DESC"
	if not IsNullRs(jRs) then
		jRs.movefirst
		if not jRs.eof then
			jcLastLoginDate = GetX(jRs, "cDate")
			jcLastLoginTime = GetX(jRs, "cTime")
		end if
	end if
	CloseRs(jRs)
	DisconnectDB(jConn)
end if
jSQL = "UPDATE T_PP_LOGIN_ATTEMPT SET cStatus='F', cLogoutDate='" & jcSysDate & "', cLogoutTime='" & jcSysTime & "' WHERE cUser='" & jcUser & "' AND cStatus='A'"
ExecSQL jSQL
jSQL = "INSERT INTO T_PP_LOGIN_ATTEMPT(cUser, cDate, cTime" & _
	", cWasSuccessful, cIsAdmin" & _
	", cToken, cStatus" & _
	") VALUES (" & _
	MakeInsX(jcUser) & "," & MakeInsX(jcSysDate) & "," & MakeInsX(jcSysTime) & _
	"," & MakeInsX(jcWasSuccessful) & "," & MakeInsX(jcIsAdmin) & _
	"," & MakeInsX(jcToken) & "," & MakeInsX("A") & _
	")"
ExecSQL jSQL
oJSON.data("cSQL") = jSQL
oJSON.data("cUser") = jcUser
oJSON.data("cName") = jcName
oJSON.data("cToken") = jcToken
oJSON.data("cIsAdmin") = jcIsAdmin
oJSON.data("cIsProcessOwner") = jcIsProcessOwner
oJSON.data("cRole") = jcRole
oJSON.data("cLastLoginDate") = jcLastLoginDate
oJSON.data("cLastLoginTime") = jcLastLoginTime
oJSON.data("cErrorMessage") = jcRemarks
oJSON.data("bIsError") = jbIsError


response.write oJSON.JSONoutput()
%>
Hello: <%= jcSysDate %> / <%= jcUser %>