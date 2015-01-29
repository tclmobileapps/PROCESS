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
Dim jaVertical, jaProduct, jaName, jaShortName, jaDisplayOrder, jaIsActive
Dim jcVertical, jcProduct, jcName, jcShortName, jnDisplayOrder, jcIsActive
Dim ji, jnIndex, jj
Dim jnDoneProductCount

j1 = GetPostParam("1")
j2 = GetPostParam("2")
jnInRecs = cLng(GetPostParam("nInRecs"))
for ji = 1 to 6
	jcParam(ji) = GetPostParam("P" & ji)
next
GetSysDateTime jcSysDate, jcSysTime
ClearDebugTables
jbIsError = false
jcErrorMessage = ""
set oJSON = InitJSON("PutVertical")

if not jbIsError then
	if not ValidateToken(j1, j2) then
		jbIsError = true
		jcErrorMessage = "Invalid token. Please login once again."
	end if
end if

if not jbIsError then
	jaVertical = split(jcParam(1), GetParamDelim())
	jaProduct = split(jcParam(2), GetParamDelim())
	jaName = split(jcParam(3), GetParamDelim())
	jaShortName = split(jcParam(4), GetParamDelim())
	jaDisplayOrder = split(jcParam(5), GetParamDelim())
	jaIsActive = split(jcParam(6), GetParamDelim())
	jnIndex = LBound(jaVertical)
	jnDoneProductCount=0
	for ji = 1 to jnInRecs
		jcVertical = jaVertical(jnIndex)
		jcProduct = jaProduct(jnIndex)
		jcName = jaName(jnIndex)
		jcShortName = jaShortName(jnIndex)
		jnDisplayOrder = cLng(jaDisplayOrder(jnIndex))
		jcIsActive = jaIsActive(jnIndex)

		if GetCount("T_PP_PRODUCT", "cVertical='" & jcVertical & "' AND cProduct='" & jcProduct & "'") = 1 then
			jSQL = "UPDATE T_PP_PRODUCT SET cName=" & MakeUpdX(jcName) & _
				", cShortName=" & MakeUpdX(jcShortName) & _
				", nDisplayOrder=" & jnDisplayOrder & _
				", cIsActive=" & MakeUpdX(jcIsActive) & _
				" WHERE cVertical='" & jcVertical & "' AND cProduct='" & jcProduct & "'"
			ExecSQL jSQL
		else
			jSQL = "INSERT INTO T_PP_PRODUCT(cVertical, cProduct, cName" & _
				", cShortName, nDisplayOrder, cIsActive" & _
				") VALUES (" & _
				MakeInsX(jcVertical) & "," & MakeInsX(jcProduct) & "," & MakeInsX(jcName) & _
				", " & MakeInsX(jcShortName) & "," & MakeInsL(jnDisplayOrder) & "," & MakeInsX(jcIsActive) & _
				")"
			ExecSQL jSQL
		end if

		jnIndex = jnIndex + 1
		jnDoneProductCount = jnDoneProductCount + 1
	next
end if

oJSON.data("bIsError") = jbIsError
oJSON.data("cErrorMessage") = jcErrorMessage
if not jbIsError then
	oJSON.data("cInfo") = "Uploaded " & jnDoneProductCount & " Product record(s)."
end if
response.write oJSON.JSONoutput()
%>
