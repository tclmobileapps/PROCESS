<!DOCTYPE html>
<html>
<head lang="en">
	<title>Process Portal</title>
	<link href='http://fonts.googleapis.com/css?family=Wendy+One|Libre+Baskerville|Monoton' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/mystyle.css">
</head>

<%
Dim jcFunc
jcFunc = request("txtFunc")
%>

<body>
<section id="main">
<div id="prodbox">
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

<script id="prodstpl" type="text/template">
	{{#prods}}	
		<div class="prod">
			<h2>{{cFunction}} Products</h2>
			<a href="proc.asp?txtFunc={{cFunction}}&txtProd={{cProduct}}">
				<img src="images/{{cFunction}}_{{cProduct}}_tn.jpg" alt="Photo of {{cName}}" />
			</a>
			<h3>{{cProduct}}</h3>
			<h4>{{cName}}</h4>
			<table border=0>
				<tr>
					<td>Version: </td>
					<td>{{cVersion}}</td>
				</tr>
				<tr>
					<td>Date:</td>
					<td>{{cDate}}</td>
				</tr>
			</table>
			<p>There are {{nProcess}} processes documented for {{cName}}</p>
			<br/>
			<p class="note">Click on the image to select the product.</p>
		</div>
	{{/prods}}
</script>

<script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="js/jquery.cycle.all-3.03.min.js" type="text/javascript"></script>
<script src="js/mustache-0.8.1.min.js" type="text/javascript"></script>
<script type="text/javascript">
var jscFunc = "<%= jcFunc %>";
$(function() {
	$.getJSON('json/m_product_' + jscFunc + '.json', function(data) {
		var template = $('#prodstpl').html();
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