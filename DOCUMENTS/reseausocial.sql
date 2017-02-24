-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema reseausocial
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `reseausocial` ;

-- -----------------------------------------------------
-- Schema reseausocial
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `reseausocial` DEFAULT CHARACTER SET utf8 ;
USE `reseausocial` ;

-- -----------------------------------------------------
-- Table `reseausocial`.`utilisateurs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reseausocial`.`utilisateurs` (
  `utilisateur` VARCHAR(100) NOT NULL,
  `code` VARCHAR(255) NULL,
  `nom` VARCHAR(255) NULL DEFAULT NULL,
  `prenom` VARCHAR(255) NULL DEFAULT NULL,
  `admin` INT(11) NULL DEFAULT NULL,
  `actif` INT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`utilisateur`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reseausocial`.`messages`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reseausocial`.`messages` (
  `idMessages` INT(11) NOT NULL AUTO_INCREMENT,
  `texte` LONGTEXT NULL DEFAULT NULL,
  `dateReponse` TIMESTAMP NULL DEFAULT NULL,
  `idMessagesOrigine` INT(11) NULL DEFAULT NULL,
  `utilisateurs_utilisateur` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idMessages`),
  INDEX `fk_Messages_Messages_idx` (`idMessagesOrigine` ASC),
  INDEX `fk_Messages_utilisateurs1_idx` (`utilisateurs_utilisateur` ASC),
  CONSTRAINT `fk_Messages_Messages`
    FOREIGN KEY (`idMessagesOrigine`)
    REFERENCES `reseausocial`.`messages` (`idMessages`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Messages_utilisateurs1`
    FOREIGN KEY (`utilisateurs_utilisateur`)
    REFERENCES `reseausocial`.`utilisateurs` (`utilisateur`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `reseausocial`.`contacts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reseausocial`.`contacts` (
  `utilisateursOrigine` VARCHAR(100) NOT NULL,
  `utilisateursDestinataire` VARCHAR(100) NOT NULL,
  `dateActionOrigine` TIMESTAMP NULL,
  `dateActionDestinataire` TIMESTAMP NULL,
  `etat` VARCHAR(1) NULL,
  PRIMARY KEY (`utilisateursOrigine`, `utilisateursDestinataire`),
  INDEX `fk_utilisateurs_has_utilisateurs_utilisateurs2_idx` (`utilisateursDestinataire` ASC),
  INDEX `fk_utilisateurs_has_utilisateurs_utilisateurs1_idx` (`utilisateursOrigine` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;



INSERT INTO `reseausocial`.`utilisateurs` (`utilisateur`) VALUES ('A');
INSERT INTO `reseausocial`.`utilisateurs` (`utilisateur`) VALUES ('B');
INSERT INTO `reseausocial`.`utilisateurs` (`utilisateur`) VALUES ('C');

INSERT INTO `reseausocial`.`contacts` (`utilisateursOrigine`, `utilisateursDestinataire`, `etat`) VALUES ('A', 'B', 'V');
INSERT INTO `reseausocial`.`contacts` (`utilisateursOrigine`, `utilisateursDestinataire`, `etat`) VALUES ('A', 'C', 'A');
INSERT INTO `reseausocial`.`contacts` (`utilisateursOrigine`, `utilisateursDestinataire`, `etat`) VALUES ('B', 'C', 'V');

INSERT INTO `reseausocial`.`messages` (`texte`, `utilisateurs_utilisateur`) VALUES ('test', 'A');
INSERT INTO `reseausocial`.`messages` (`texte`, `utilisateurs_utilisateur`) VALUES ('test', 'B');
INSERT INTO `reseausocial`.`messages` (`texte`, `utilisateurs_utilisateur`) VALUES ('test', 'C');


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


create view reseausocial.vueListeUtilisateurs as 
SELECT a.* ,  b.* , c.utilisateur as utilisateur2,  c.nom as nom2, c.prenom as prenom2
FROM reseausocial.utilisateurs a
left join reseausocial.contacts b on a.utilisateur in (b.utilisateursOrigine , b.utilisateursDestinataire )
left join reseausocial.utilisateurs c on b.utilisateursOrigine is not null and c.utilisateur  = case when a.utilisateur = b.utilisateursOrigine then b.utilisateursDestinataire else b.utilisateursOrigine end
order by a.utilisateur, c.utilisateur;



create view reseausocial.vueListeActualite as 
select a.* , b.utilisateur , b.nom , b.prenom 
, d.utilisateur as utilisateurReponse , d.nom as nomReponse, d.prenom as prenomReponse
, c.texte as texteReponse , c.dateReponse as dateReponse2
from reseausocial.messages a
join reseausocial.utilisateurs b on a.utilisateurs_utilisateur = b.utilisateur
left join reseausocial.messages c on a.idMessages= c.idMessagesOrigine
left join reseausocial.utilisateurs d on d.utilisateur = c.utilisateurs_utilisateur
where a.idMessagesOrigine is null 
and a.utilisateurs_utilisateur in ( 
	select z.utilisateur2 
    from reseausocial.vueListeUtilisateurs z
	where a.utilisateurs_utilisateur = z.utilisateur and z.etat = 'V'
	union 
	select z.utilisateur 
    from reseausocial.vueListeUtilisateurs z
	where a.utilisateurs_utilisateur = z.utilisateur2 and z.etat = 'V'
	union 
	select a.utilisateurs_utilisateur )
order by a.dateReponse, c.dateReponse;