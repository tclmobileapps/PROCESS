<!DOCTYPE html>
<html>
<head lang="en">
	<title>Process Portal</title>
	<link href='http://fonts.googleapis.com/css?family=Wendy+One|Libre+Baskerville|Monoton' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/mystyle.css">
</head>

<%
Dim jcFunc, jcProd
jcFunc = request("txtFunc")
jcProd = request("txtProd")
%>

<body>
<section id="main">
<div id="procbox">
	<center>
	<a href="#" id="prev_btn">&laquo;</a>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="#" id="next_btn">&raquo;</a>
	</center>
	<div id="carousel"></div>
</div>
</section>

<script id="procstpl" type="text/template">
	{{#procs}}	
		<div class="proc">
			<a href="procView.asp?txtFunc={{cFunction}}&txtProd={{cProduct}}&txtProc={{cProcess}}">
			<h3>{{cFunction}} - {{cProduct}}</h3>
			<h3>{{cProcess}}</h3>
			<h4>{{cName}}</h4>
			<table border="0">
				<tr>
					<td>Version</td>
					<td>{{cVersion}}</td>
				</tr>
				<tr>
					<td>Date</td>
					<td>{{cDate}}</td>
				</tr>
			</table>
			<br/>
			</a>
			<p class="note">Click anywhere to select the process.</p>
		</div>
	{{/procs}}
</script>

<script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="js/jquery.cycle.all-3.03.min.js" type="text/javascript"></script>
<script src="js/mustache-0.8.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
var jscFunc = "<%= jcFunc %>";
var jscProd = "<%= jcProd %>";
$(function() {
	$.getJSON('json/m_process_' + jscFunc + '_' + jscProd + '.json', function(data) {
		var template = $('#procstpl').html();
		var html = Mustache.to_html(template, data);
		$('#carousel').html(html);

			$('#carousel').cycle({
				fx: 'fade',
				pause: 1,
				next: '#next_btn',
				prev: '#prev_btn',
				speed: 500,
				timeout: 3000
			});
	}); // getJSON
}); // function

</script>
</body>
</html>