<!DOCTYPE html>
<html>
<head lang="en">
	<title>Process Portal</title>
	<link href='http://fonts.googleapis.com/css?family=Wendy+One|Libre+Baskerville|Monoton' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/mystyle.css">
</head>

<%
Dim jcFunc, jcProd, jcProc
jcFunc = request("txtFunc")
jcProd = request("txtProd")
jcProc = request("txtProc")
%>

<body>
<section id="main">
<div id="proctabbox">
	<center>
	</center>
	<div id="carousel"></div>
</div>
</section>

<script id="proctabstpl" type="text/template">
	{{#proctabs}}	
		{{#bFirst}}
		<table border=1 cellspacing=0>
		<tr>
			<th colspan=5>{{cName}}</th>
		</tr>
		<tr>
			<th colspan=5>Version: {{cVersion}} &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {{cDate}}</th>
		</tr>
		<tr>
			<th>Srl</th>
			<th>Step</th>
			<th>Control</th>
			<th>Responsibility</th>
			<th>Metrics</th>
		</tr>
		{{/bFirst}}
		{{^bFirst}}
		<tr>
			<td>{{nSrl}}</td>
			<td>{{cStep}}</td>
			<td>
				{{cControl}}
				{{#bHasDocs}}

					{{#aDocs}}
						<span>
						<a href=# onclick=DownloadDoc(this,'{{cDiskFileName}}')>{{cDisplayText}} <img src="images/download.png"></img></a>
						<input type="hidden" value='{{cFileName}}'/>
						</span><br/>
					{{/aDocs}}
				{{/bHasDocs}}
			</td>
			<td>{{cResponsibility}}</td>
			{{#bMergedOnTop}}
			<td rowspan={{nMergeMetrics}}>{{cMetrics}}</td>
			{{/bMergedOnTop}}
		</tr>
		{{/bFirst}}
		{{#bLast}}
		</table>
		{{/bLast}}
	{{/proctabs}}
</script>

<script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="js/jquery.cycle.all-3.03.min.js" type="text/javascript"></script>
<script src="js/mustache-0.8.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
var jscFunc = "<%= jcFunc %>";
var jscProd = "<%= jcProd %>";
var jscProc = "<%= jcProc %>";
$(function() {
	$.getJSON('json/d_' + jscFunc + '_' + jscProd + '_' + jscProc + '.json', function(data) {
		var template = $('#proctabstpl').html();
		var html = Mustache.to_html(template, data);
		$('#carousel').html(html);
	}); // getJSON
}); // function
function DownloadDoc(elem, pcDiskFileName)
{
	var filename=$(elem).closest('span').find('input').val();
	$('#txtFileName').val(filename);
	$('#txtDiskFileName').val(pcDiskFileName);
	$('#frmDownload').submit();
}
</script>
<form name="frmDownload" id="frmDownload" method="POST" action="frmDownloadDoc.asp">
	<input type="hidden" name="txtFileName" id="txtFileName"></input>
	<input type="hidden" name="txtDiskFileName" id="txtDiskFileName"></input>
</form>
</body>
</html>