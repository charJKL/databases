-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Wersja serwera:               5.7.10 - MySQL Community Server (GPL)
-- Serwer OS:                    Win32
-- HeidiSQL Wersja:              9.3.0.4998
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Zrzut struktury bazy danych przypisanie
CREATE DATABASE IF NOT EXISTS `przypisanie` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `przypisanie`;


-- Zrzut struktury tabela przypisanie.grupa
CREATE TABLE IF NOT EXISTS `grupa` (
  `grupa_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `semestr_id` int(10) unsigned NOT NULL,
  `realizowany_kierunek_id` int(10) unsigned NOT NULL,
  `nazwa` varchar(50) NOT NULL,
  `typ` int(10) unsigned NOT NULL,
  `ilosc` int(10) unsigned NOT NULL,
  PRIMARY KEY (`grupa_id`),
  KEY `FK_grupa_realizowany_kierunek` (`realizowany_kierunek_id`),
  KEY `FK_grupa_semestr` (`semestr_id`),
  CONSTRAINT `FK_grupa_realizowany_kierunek` FOREIGN KEY (`realizowany_kierunek_id`) REFERENCES `realizowany_kierunek` (`realizowany_kierunek_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_grupa_semestr` FOREIGN KEY (`semestr_id`) REFERENCES `semestr` (`semestr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.kategoria
CREATE TABLE IF NOT EXISTS `kategoria` (
  `kategoria_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`kategoria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.przedmiot
CREATE TABLE IF NOT EXISTS `przedmiot` (
  `przedmiot_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `kod` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `kategoria_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`przedmiot_id`),
  UNIQUE KEY `kod` (`kod`),
  KEY `FK_przedmiot_kategoria` (`kategoria_id`),
  CONSTRAINT `FK_przedmiot_kategoria` FOREIGN KEY (`kategoria_id`) REFERENCES `kategoria` (`kategoria_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.przedmiot_realizowany_kierunek
CREATE TABLE IF NOT EXISTS `przedmiot_realizowany_kierunek` (
  `przedmiot_realizowany_kierunek_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `przedmiot_id` int(10) unsigned NOT NULL,
  `semestr_id` int(10) unsigned NOT NULL,
  `realizowany_kierunek_id` int(10) unsigned NOT NULL,
  `wyklad` int(10) unsigned NOT NULL DEFAULT '0',
  `cwiczenia` int(10) unsigned NOT NULL DEFAULT '0',
  `labolatoria` int(10) unsigned NOT NULL DEFAULT '0',
  `projekty` int(10) unsigned NOT NULL DEFAULT '0',
  `seminarium` int(10) unsigned NOT NULL DEFAULT '0',
  `etcs` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`przedmiot_realizowany_kierunek_id`),
  UNIQUE KEY `przedmiot_id` (`przedmiot_id`,`realizowany_kierunek_id`,`semestr_id`),
  KEY `FK_przedmiot_realizowany_kierunek_przedmiot` (`przedmiot_id`),
  KEY `FK_przedmiot_realizowany_kierunek_realizowany_kierunek` (`realizowany_kierunek_id`),
  KEY `FK_przedmiot_realizowany_kierunek_semestr` (`semestr_id`),
  CONSTRAINT `FK_przedmiot_realizowany_kierunek_przedmiot` FOREIGN KEY (`przedmiot_id`) REFERENCES `przedmiot` (`przedmiot_id`),
  CONSTRAINT `FK_przedmiot_realizowany_kierunek_realizowany_kierunek` FOREIGN KEY (`realizowany_kierunek_id`) REFERENCES `realizowany_kierunek` (`realizowany_kierunek_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_przedmiot_realizowany_kierunek_semestr` FOREIGN KEY (`semestr_id`) REFERENCES `semestr` (`semestr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.przedmiot_wykladowca
CREATE TABLE IF NOT EXISTS `przedmiot_wykladowca` (
  `przedmiot_wykladowca_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `przedmiot_id` int(10) unsigned NOT NULL,
  `wykladowca_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`przedmiot_wykladowca_id`),
  UNIQUE KEY `wykladowca_id` (`wykladowca_id`,`przedmiot_id`),
  KEY `FK_przedmiot_wykladowca_przedmiot` (`przedmiot_id`),
  KEY `FK_przedmiot_wykladowca_wykladowca` (`wykladowca_id`),
  CONSTRAINT `FK_przedmiot_wykladowca_przedmiot` FOREIGN KEY (`przedmiot_id`) REFERENCES `przedmiot` (`przedmiot_id`),
  CONSTRAINT `FK_przedmiot_wykladowca_wykladowca` FOREIGN KEY (`wykladowca_id`) REFERENCES `wykladowca` (`wykladowca_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.realizowany_kierunek
CREATE TABLE IF NOT EXISTS `realizowany_kierunek` (
  `realizowany_kierunek_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tok_studiow_id` int(10) unsigned NOT NULL,
  `nazwa` varchar(50) NOT NULL,
  `rok_rozpoczecia` year(4) NOT NULL,
  PRIMARY KEY (`realizowany_kierunek_id`),
  UNIQUE KEY `rok_rozpoczecia` (`tok_studiow_id`,`rok_rozpoczecia`),
  CONSTRAINT `FK_realizowany_kierunek_tok_studiow` FOREIGN KEY (`tok_studiow_id`) REFERENCES `tok_studiow` (`tok_studiow_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.realizowany_przedmiot
CREATE TABLE IF NOT EXISTS `realizowany_przedmiot` (
  `realizowany_przedmiot_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wykladowca_id` int(10) unsigned DEFAULT NULL,
  `przedmiot_realizowany_kierunek_id` int(10) unsigned NOT NULL,
  `grupa_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`realizowany_przedmiot_id`),
  KEY `FK_realizowany_przedmiot_grupa` (`grupa_id`),
  KEY `FK_realizowany_przedmiot_wykladowca` (`wykladowca_id`),
  KEY `FK_realizowany_przedmiot_przedmiot_realizowany_kierunek` (`przedmiot_realizowany_kierunek_id`),
  CONSTRAINT `FK_realizowany_przedmiot_grupa` FOREIGN KEY (`grupa_id`) REFERENCES `grupa` (`grupa_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_realizowany_przedmiot_przedmiot_realizowany_kierunek` FOREIGN KEY (`przedmiot_realizowany_kierunek_id`) REFERENCES `przedmiot_realizowany_kierunek` (`przedmiot_realizowany_kierunek_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_realizowany_przedmiot_wykladowca` FOREIGN KEY (`wykladowca_id`) REFERENCES `wykladowca` (`wykladowca_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.semestr
CREATE TABLE IF NOT EXISTS `semestr` (
  `semestr_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rok` year(4) NOT NULL,
  `okres` int(10) unsigned NOT NULL,
  PRIMARY KEY (`semestr_id`),
  UNIQUE KEY `rok` (`rok`,`okres`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.tok_studiow
CREATE TABLE IF NOT EXISTS `tok_studiow` (
  `tok_studiow_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `kod` varchar(50) NOT NULL,
  `tryb` int(10) unsigned NOT NULL,
  `profil_akademicki` int(10) unsigned NOT NULL,
  `semestry` int(10) unsigned NOT NULL,
  `stopien` int(10) unsigned NOT NULL,
  `specjalizacja_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`tok_studiow_id`),
  KEY `FK_tok_studiow_tok_studiow` (`specjalizacja_id`),
  CONSTRAINT `FK_tok_studiow_tok_studiow` FOREIGN KEY (`specjalizacja_id`) REFERENCES `tok_studiow` (`tok_studiow_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury tabela przypisanie.wykladowca
CREATE TABLE IF NOT EXISTS `wykladowca` (
  `wykladowca_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `imie` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `nazwisko` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `stopien` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`wykladowca_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Zrzut struktury widok przypisanie.realizowany_kierunek_view
-- Tworzenie tymczasowej tabeli aby przezwyciężyć błędy z zależnościami w WIDOKU
CREATE TABLE `realizowany_kierunek_view` (
	`realizowany_kierunek_id` INT(10) UNSIGNED NOT NULL,
	`nazwa` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`rok_rozpoczecia` YEAR NOT NULL,
	`tok_studiow` VARCHAR(50) NULL COLLATE 'utf8_bin',
	`kod` VARCHAR(50) NULL COLLATE 'utf8_general_ci',
	`tryb` INT(10) UNSIGNED NULL,
	`profil_akademicki` INT(10) UNSIGNED NULL,
	`semestry` INT(10) UNSIGNED NULL,
	`stopien` INT(10) UNSIGNED NULL
) ENGINE=MyISAM;


-- Zrzut struktury widok przypisanie.realizowany_przedmiot_view
-- Tworzenie tymczasowej tabeli aby przezwyciężyć błędy z zależnościami w WIDOKU
CREATE TABLE `realizowany_przedmiot_view` (
	`realizowany_przedmiot_id` INT(10) UNSIGNED NOT NULL,
	`realizowany_kierunek_id` INT(10) UNSIGNED NOT NULL,
	`grupa_id` INT(10) UNSIGNED NOT NULL,
	`grupa` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`typ` INT(10) UNSIGNED NOT NULL,
	`przedmiot_id` INT(11) UNSIGNED NOT NULL,
	`przedmiot` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`kod` VARCHAR(50) NOT NULL COLLATE 'utf8_bin',
	`przedmiot_realizowany_kierunek_id` INT(10) UNSIGNED NOT NULL,
	`semestr_id` INT(10) UNSIGNED NOT NULL,
	`wyklad` INT(10) UNSIGNED NOT NULL,
	`cwiczenia` INT(10) UNSIGNED NOT NULL,
	`labolatoria` INT(10) UNSIGNED NOT NULL,
	`projekty` INT(10) UNSIGNED NOT NULL,
	`seminarium` INT(10) UNSIGNED NOT NULL,
	`etcs` INT(10) UNSIGNED NOT NULL,
	`wykladowca_id` INT(10) UNSIGNED NULL,
	`imie` VARCHAR(50) NULL COLLATE 'utf8_bin',
	`nazwisko` VARCHAR(50) NULL COLLATE 'utf8_bin',
	`stopien` VARCHAR(50) NULL COLLATE 'utf8_bin'
) ENGINE=MyISAM;


-- Zrzut struktury procedura przypisanie.dostepne_przedmioty_dla_realizowanego_kierunku
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostepne_przedmioty_dla_realizowanego_kierunku`(IN `realizowany_kierunek_id` INT, IN `semestr_id` INT)
BEGIN
    SELECT 
        * 
    FROM 
        przedmiot  p
    WHERE
        p.przedmiot_id NOT IN 
        (
            SELECT 
                przedmiot_id
            FROM
                przedmiot_realizowany_kierunek prk
            WHERE
                prk.realizowany_kierunek_id = realizowany_kierunek_id  
            AND prk.semestr_id = semestr_id                  
        );
END//
DELIMITER ;


-- Zrzut struktury procedura przypisanie.dostepne_przedmioty_dla_wykladowcy
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostepne_przedmioty_dla_wykladowcy`(IN `wykladowca_id` INT)
BEGIN
    SELECT 
        * 
    FROM 
        przedmiot  p
    WHERE
        p.przedmiot_id NOT IN 
        (
            SELECT 
                przedmiot_id
            FROM
                przedmiot_wykladowca pw
            WHERE
                pw.wykladowca_id = wykladowca_id                
        );
END//
DELIMITER ;


-- Zrzut struktury procedura przypisanie.dostepne_realizowany_kierunki_dla_przedmiotu
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostepne_realizowany_kierunki_dla_przedmiotu`(IN `przedmiot_id` INT, IN `semestr_id` INT)
BEGIN
    SELECT 
        * 
    FROM 
        realizowany_kierunek  rk
    WHERE
        rk.realizowany_kierunek_id NOT IN 
        (
            SELECT 
                realizowany_kierunek_id
            FROM
                przedmiot_realizowany_kierunek prk
            WHERE
                prk.przedmiot_id = przedmiot_id    
            AND prk.semestr_id = semestr_id                
        );
END//
DELIMITER ;


-- Zrzut struktury procedura przypisanie.dostepni_wykladowcy_dla_przedmiotu
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `dostepni_wykladowcy_dla_przedmiotu`(IN `przedmiot_id` INT)
BEGIN
    SELECT 
        * 
    FROM 
        wykladowca  w
    WHERE
        w.wykladowca_id NOT IN 
        (
            SELECT 
                wykladowca_id
            FROM
                przedmiot_wykladowca pw
            WHERE
                pw.przedmiot_id = przedmiot_id        
        );
END//
DELIMITER ;


-- Zrzut struktury procedura przypisanie.mozliwy_prowadzacy_dla_przedmiotu
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `mozliwy_prowadzacy_dla_przedmiotu`(IN `przedmiot_id` INT)
BEGIN
    SELECT 
        pw.*,
        w.*
    FROM
        przedmiot_wykladowca pw
        NATURAL JOIN wykladowca w
    WHERE
        pw.przedmiot_id = przedmiot_id;
END//
DELIMITER ;


-- Zrzut struktury procedura przypisanie.pokaz_przydzial_dla_wykladowcy_na_semestr
DELIMITER //
CREATE DEFINER=`root`@`localhost` PROCEDURE `pokaz_przydzial_dla_wykladowcy_na_semestr`(IN `wykladowca_id` INT, IN `semestr_id` INT)
BEGIN
    SELECT 
        *
    FROM
        realizowany_przedmiot_view rpv
    WHERE
        rpv.wykladowca_id = wykladowca_id 
    AND rpv.semestr_id = semestr_id
    ORDER BY
         realizowany_kierunek_id;
END//
DELIMITER ;


-- Zrzut struktury wyzwalacz przypisanie.grupa_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `grupa_after_insert` AFTER INSERT ON `grupa` FOR EACH ROW BEGIN
    -- deklaracja zmiennych
    DECLARE add_flag BOOLEAN DEFAULT false;
    DECLARE przedmiot_realizowany_kierunek_id INT;
    DECLARE wyklad INT;
    DECLARE cwiczenia INT;
    DECLARE labolatorium INT;
    DECLARE projekt INT;
    DECLARE seminarium INT;
       
    -- deklaracja kursora
    DECLARE przedmoty_do_realizacji_end INTEGER DEFAULT 0;
    DECLARE przedmoty_do_realizacji CURSOR FOR 
    (
        SELECT 
            prk.przedmiot_realizowany_kierunek_id,
            prk.wyklad,
            prk.cwiczenia,
            prk.labolatoria,
            prk.projekty,
            prk.seminarium
        FROM 
            przedmiot_realizowany_kierunek prk 
        WHERE 
            prk.realizowany_kierunek_id = NEW.realizowany_kierunek_id 
        AND prk.semestr_id = NEW.semestr_id
    );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET przedmoty_do_realizacji_end = 1;

    -- trigger
    OPEN przedmoty_do_realizacji;
    
    do_realizacji: LOOP
        SET add_flag = false;
        FETCH przedmoty_do_realizacji INTO przedmiot_realizowany_kierunek_id,wyklad,cwiczenia,labolatorium,projekt,seminarium;
        IF przedmoty_do_realizacji_end THEN LEAVE do_realizacji; END IF;
         
        IF( NEW.typ = 0 AND wyklad > 0 ) THEN SET add_flag = true; END IF;
        IF( NEW.typ = 1 AND cwiczenia > 0 ) THEN SET add_flag = true; END IF;
        IF( NEW.typ = 2 AND labolatorium > 0 ) THEN SET add_flag = true; END IF;
        IF( NEW.typ = 3 AND projekt > 0 ) THEN SET add_flag = true; END IF;
        IF( NEW.typ = 4 AND seminarium > 0 ) THEN SET add_flag = true; END IF;

        IF ( add_flag ) THEN
            INSERT INTO
                realizowany_przedmiot (`przedmiot_realizowany_kierunek_id`,`grupa_id`)
            VALUES
                (przedmiot_realizowany_kierunek_id,NEW.grupa_id);  
        END IF;
    END LOOP do_realizacji;
    
    CLOSE przedmoty_do_realizacji;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Zrzut struktury wyzwalacz przypisanie.przedmiot_realizowany_kierunek_after_insert
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `przedmiot_realizowany_kierunek_after_insert` AFTER INSERT ON `przedmiot_realizowany_kierunek` FOR EACH ROW BEGIN
    -- deklaracja zmiennych
    DECLARE add_flag BOOLEAN DEFAULT false;
    DECLARE grupa_id INT;
    DECLARE typ INT;
    
    -- deklaracja kursora
    DECLARE przedmoty_do_realizacji_end INTEGER DEFAULT 0;
    DECLARE przedmoty_do_realizacji CURSOR FOR 
    (
        SELECT 
            g.grupa_id,
            g.typ
        FROM
            grupa g
        WHERE 
            g.realizowany_kierunek_id = NEW.realizowany_kierunek_id  
        AND g.semestr_id = NEW.semestr_id            
    );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET przedmoty_do_realizacji_end = 1;

    -- trigger
    OPEN przedmoty_do_realizacji;
    
    do_realizacji: LOOP
        SET add_flag = false;
        FETCH przedmoty_do_realizacji INTO grupa_id,typ;
         IF przedmoty_do_realizacji_end THEN LEAVE do_realizacji; END IF;
        IF( typ = 0 AND NEW.wyklad > 0 ) THEN SET add_flag = true; END IF;
        IF( typ = 1 AND NEW.cwiczenia > 0 ) THEN SET add_flag = true; END IF;
        IF( typ = 2 AND NEW.labolatoria > 0 ) THEN SET add_flag = true; END IF;
        IF( typ = 3 AND NEW.projekty > 0 ) THEN SET add_flag = true; END IF;
        IF( typ = 4 AND NEW.seminarium > 0 ) THEN SET add_flag = true; END IF;
        
        IF ( add_flag ) THEN
            INSERT INTO
                realizowany_przedmiot (`przedmiot_realizowany_kierunek_id`,`grupa_id`)
            VALUES
                (NEW.przedmiot_realizowany_kierunek_id,grupa_id);  
        END IF;
    END LOOP do_realizacji;
    
    CLOSE przedmoty_do_realizacji;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Zrzut struktury wyzwalacz przypisanie.przedmiot_realizowany_kierunek_after_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `przedmiot_realizowany_kierunek_after_update` AFTER UPDATE ON `przedmiot_realizowany_kierunek` FOR EACH ROW BEGIN
    -- deklaracja zmiennych
    DECLARE add_flag BOOLEAN DEFAULT false;
    DECLARE remove_flag BOOLEAN DEFAULT false;
    DECLARE grupa_id INT;
    DECLARE typ INT;
    
    -- deklaracja kursora
    DECLARE przedmoty_do_realizacji_end INTEGER DEFAULT 0;
    DECLARE przedmoty_do_realizacji CURSOR FOR 
    (
        SELECT 
            g.grupa_id,
            g.typ
        FROM
            grupa g
        WHERE 
            g.realizowany_kierunek_id = NEW.realizowany_kierunek_id  
        AND g.semestr_id = NEW.semestr_id
    );
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET przedmoty_do_realizacji_end = 1;

    -- trigger
    OPEN przedmoty_do_realizacji;
    do_realizacji: LOOP
        SET add_flag = false;
        SET remove_flag = false;
        FETCH przedmoty_do_realizacji INTO grupa_id,typ;
        
        IF przedmoty_do_realizacji_end THEN LEAVE do_realizacji; END IF;
        
        CASE typ
            WHEN 0 THEN BEGIN
                IF NEW.wyklad <> OLD.wyklad THEN
                    IF (NEW.wyklad = 0) THEN SET remove_flag=true; END IF;
                    IF (OLD.wyklad = 0) THEN SET add_flag=true; END IF;
                END IF;
            END;
            
            WHEN 1 THEN BEGIN
                IF NEW.cwiczenia <> OLD.cwiczenia THEN
                    IF NEW.cwiczenia = 0 THEN SET remove_flag=true; END IF;
                    IF OLD.cwiczenia = 0 THEN SET add_flag=true; END IF;
                END IF;
            END;
            
            WHEN 2 THEN BEGIN
                IF NEW.labolatoria <> OLD.labolatoria THEN
                    IF NEW.labolatoria = 0 THEN SET remove_flag=true; END IF;
                    IF OLD.labolatoria = 0 THEN SET add_flag=true; END IF;
                END IF;
            END;
            
            WHEN 3 THEN BEGIN
                IF NEW.projekty <> OLD.projekty THEN
                    IF NEW.projekty = 0 THEN SET remove_flag=true; END IF;
                    IF OLD.projekty = 0 THEN SET add_flag=true; END IF;
                END IF;
            END;
                 
            WHEN 4 THEN BEGIN
                IF NEW.seminarium <> OLD.seminarium THEN
                    IF NEW.seminarium = 0 THEN SET remove_flag=true; END IF;
                    IF OLD.seminarium = 0 THEN SET add_flag=true; END IF;
                END IF;
            END;
            
        END CASE;
       
        IF ( add_flag ) THEN
            INSERT INTO
                realizowany_przedmiot (`przedmiot_realizowany_kierunek_id`,`grupa_id`)
            VALUES
                (NEW.przedmiot_realizowany_kierunek_id,grupa_id);  
        END IF;
        
        IF ( remove_flag ) THEN
            DELETE FROM realizowany_przedmiot WHERE przedmiot_realizowany_kierunek_id=NEW.przedmiot_realizowany_kierunek_id AND grupa_id=grupa_id LIMIT 1; 
        END IF;
    END LOOP do_realizacji;
    
    CLOSE przedmoty_do_realizacji;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Zrzut struktury wyzwalacz przypisanie.realizowany_przedmiot_before_update
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `realizowany_przedmiot_before_update` BEFORE UPDATE ON `realizowany_przedmiot` FOR EACH ROW BEGIN
    DECLARE przedmiot_idt INT;
    
    IF( NEW.wykladowca_id IS NOT NULL) THEN
    
        SET przedmiot_idt = ( SELECT przedmiot_id FROM przedmiot_realizowany_kierunek WHERE przedmiot_realizowany_kierunek_id = NEW.przedmiot_realizowany_kierunek_id);
        
        IF ( (SELECT przedmiot_wykladowca_id FROM przedmiot_wykladowca WHERE wykladowca_id = NEW.wykladowca_id AND przedmiot_id = przedmiot_idt ) IS NULL ) THEN
           SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This teacher dont have authority to realize this class.';
        END IF;
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;


-- Zrzut struktury widok przypisanie.realizowany_kierunek_view
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `realizowany_kierunek_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `realizowany_kierunek_view` AS SELECT 
    rk.realizowany_kierunek_id,
    rk.nazwa,
    rk.rok_rozpoczecia,
    tk.nazwa as `tok_studiow`,
    tk.kod,
    tk.tryb,
    tk.profil_akademicki,
    tk.semestry,
    tk.stopien
FROM
    realizowany_kierunek rk
    LEFT JOIN tok_studiow tk USING (tok_studiow_id) ;


-- Zrzut struktury widok przypisanie.realizowany_przedmiot_view
-- Usuwanie tabeli tymczasowej i tworzenie ostatecznej struktury WIDOKU
DROP TABLE IF EXISTS `realizowany_przedmiot_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` VIEW `realizowany_przedmiot_view` AS SELECT 
    rp.realizowany_przedmiot_id,
    g.realizowany_kierunek_id,
    g.grupa_id,
    g.nazwa as 'grupa',
    g.typ,
    p.przedmiot_id,
    p.nazwa as 'przedmiot',
    p.kod,
    prk.przedmiot_realizowany_kierunek_id,
    prk.semestr_id,
    prk.wyklad,
    prk.cwiczenia,
    prk.labolatoria,
    prk.projekty,
    prk.seminarium,
    prk.etcs,
    w.wykladowca_id,
    w.imie,
    w.nazwisko,
    w.stopien
FROM
    realizowany_przedmiot rp
    NATURAL JOIN grupa g
    NATURAL LEFT JOIN wykladowca w
    NATURAL JOIN przedmiot_realizowany_kierunek prk
    JOIN  przedmiot p ON p.przedmiot_id = prk.przedmiot_id ;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
