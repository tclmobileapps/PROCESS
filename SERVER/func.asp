<!DOCTYPE html>
<html>
<head lang="en">
	<title>Process Portal</title>
	<link href='http://fonts.googleapis.com/css?family=Wendy+One|Libre+Baskerville|Monoton' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/mystyle.css">
</head>
<body>

<section id="main">
<div id="funcbox">
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

<script id="funcstpl" type="text/template">
	{{#funcs}}	
		<div class="func">
			<h2>Choose a Function</h2>
			<a href="prod.asp?txtFunc={{cFunction}}">
				<img src="images/{{cFunction}}_tn.jpg" alt="Photo of {{cName}}" />
			</a>
			<h3>{{cFunction}}</h3>
			<h4>{{cName}}</h4>
			<p>There are {{nProducts}} products documented for {{cName}}</p>
			<br/>
			<p class="note">Click on the image to select the function.</p>
		</div>
	{{/funcs}}
</script>

<script src="js/jquery-1.11.1.min.js" type="text/javascript"></script>
<script src="js/jquery.cycle.all-3.03.min.js" type="text/javascript"></script>
<script src="js/mustache-0.8.1.min.js" type="text/javascript"></script>
<script type="text/javascript">

$(function() {
	$.getJSON('json/m_function.json', function(data) {
		var template = $('#funcstpl').html();
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