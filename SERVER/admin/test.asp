<!--#include file="General.asp"-->
<!--#include file="PPGeneral.asp"-->
<% Response.CacheControl = "no-cache" %>
<% Response.AddHeader "Pragma", "no-cache" %>
<% Response.Expires = -1 %>
Count-A: <%= GetCount("T_PP_FUNC", "cFunc='CFAB'") %><br/>
<%
Dim x
x = CreateJSON_Func()
%>
Count-B: <%= GetCount("T_PP_FUNC", "cIsActive='Y'") %><br/>
Count-C: <%= GetCount("T_PP_FUNC", "cIsActive='N'") %><br/>