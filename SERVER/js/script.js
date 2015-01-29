function frmLogin_try2Login()
{
	if(!ValidText(document.getElementById("frmLogin_txtUser"),6,10,false,"Please enter the user code",true)) {
		return;
	}
	if(!ValidText(document.getElementById("frmLogin_txtPassword"),1,20,false,"Please enter the password",true)) {
		return;
	}
  var jcUser    	= $('#frmLogin_txtUser').val(),
    	jcPassword  = $('#frmLogin_txtPassword').val();
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_PP_ValidateUserLogin.asp?callback=?",
    data: { 'txtParamcUser': jcUser, 'txtParamcPassword': jcPassword },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to login: " + o.cErrorMessage);
        return;
      }
      else
      {
        Z_SetMe(jcUser);
        Z_SetToken(o.cToken);
        window.location.href = "home.html";
        return;
      }
    }
   });
}

function ShowProcess(pcProcess, pcProcessName) {
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_PP_GetProcessData.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken(),
      'txtParamcProcess': pcProcess
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to fetch process data: " + o.cErrorMessage);
        return;
      }
      else
      {
        alert("Process data fetched: " + o.cInfo);
        return;
      }
    }
   });  
}

function LocalValidateToken() {
  if( (Z_GetMe() === "") || (Z_GetToken() === "") ) {
    alert("Invalid user credentials");
    window.location.href = "index.html";
    return false;
  }
  $.ajax(
  {
    Type: "POST",
    contentType: "application/json",
    url: "api_PP_ValidateUserToken.asp?callback=?",
    data: { 
      'txtParam1': Z_GetMe(), 
      'txtParam2': Z_GetToken() 
    },
    success: function(rv) {
      var o = jQuery.parseJSON(rv);
      if(o.bIsError)
      {
        alert("Unable to valid user credentials: " + o.cErrorMessage);
        window.location.href = "index.html";
      }
      else
      {
        //alert(o.cInfo);
      }
    }
   });  
  return true;
}

function Z_InitLocalStorage() {
  Z_SetMe("");
  Z_SetToken("");
  Z_SetProcess("");
}

function Z_GetMe() {
  return localStorage.cUser;
}

function Z_GetProcess() {
  return localStorage.cProcess;
}

function Z_GetToken() {
  return localStorage.cToken;
}

function Z_SetMe(pcUser) {
  localStorage.cUser = pcUser;
}

function Z_SetProcess(pcProcess) {
  localStorage.cProcess = pcProcess;
}

function Z_SetToken(pcToken) {
  localStorage.cToken = pcToken;
}