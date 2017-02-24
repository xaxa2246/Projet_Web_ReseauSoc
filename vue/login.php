<section>
	<article>
		<form action="../control/login_control.php" method="post" accept-charset="utf-8">
		<p> Utilisateur  
			<input type="text" name="UTILISATEUR" value="" placeholder="Utilisateur" required>
			</p>
			<p> Mot de passe
			<input type="password" name="CODE" value="" placeholder="Mot de passe" required>
			</p>
			<input type="submit" name="" value="Valider">
		</form>
		<?php if (isset($_SESSION['ERROR_LOGIN'])){
			echo "<p>".$_SESSION['ERROR_LOGIN']."</p>";
		} ?>
	</article>
</section>