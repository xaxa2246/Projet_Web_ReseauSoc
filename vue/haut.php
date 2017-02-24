<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>FacedeBouc</title>
	<link rel="stylesheet" href="../vue/css/page.css">

</head>
<body>
	<header id="header" class="header">
		<H1>
					<?php 
			if(isset($_SESSION['NOM']))
			{ 
				echo '<a href="../control/page1.php" >'.$_SESSION['NOM'].'</a>' ;
			}
		?>
		</H1>
		<?php 
		if (Control::user_connected()){
			require_once('../vue/menu.php');
		}
		?>
	</header>
