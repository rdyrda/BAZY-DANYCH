
--AUTOR: RAFA£ DYRDA

--	WERSJA NA MS SQL SERVER 2008 

-- PROJEKT 2: SKRYPT (create + insert tabel):

--#########################################################################################################################

-- STWORZENIE MOJEJ BAZY DANYCH
/* Sprawdzanie czy istnieje ju¿ baza danych "PRZEDSIÊBIORSTWO_TRANSPORTOWO_US£UGOWE" */

IF EXISTS (SELECT * FROM sys.databases WHERE name='PRZEDSIÊBIORSTWO_TRANSPORTOWO_US£UGOWE')
DROP DATABASE PRZEDSIÊBIORSTWO_TRANSPORTOWO_US£UGOWE
GO

/* Tworzenie i korzystanie z bazy danych "PRZEDSIÊBIORSTWO_TRANSPORTOWO-US£UGOWA" */

CREATE DATABASE PRZEDSIÊBIORSTWO_TRANSPORTOWO_US£UGOWE
GO
USE PRZEDSIÊBIORSTWO_TRANSPORTOWO_US£UGOWE
GO

--#########################################################################################################################

-- Polecenia CREATE:
/* 1) Tabela: KIEROWCA */

/* Sprawdzanie czy istnieje tabela "Kierowca" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Kierowca')
DROP TABLE Kierowca
GO

/* Tworzenie tabeli: KIEROWCA */

CREATE TABLE Kierowca (
id_kierowca INT IDENTITY(1,1) PRIMARY KEY,
PESEL CHAR(11) NOT NULL UNIQUE,
imiê VARCHAR(40) NOT NULL CHECK(LEN(imiê)>2),
nazwisko VARCHAR(40) NOT NULL CHECK(LEN(nazwisko)>2),
miejscowoœæ VARCHAR(50) NOT NULL CHECK(LEN(miejscowoœæ)>2),
nr_domu INT NOT NULL,
nr_lokalu INT,
kod_pocztowy CHAR(6) NOT NULL,
telefon VARCHAR(9),
data_zatrudnienia DATE NOT NULL,
pensja MONEY NOT NULL CHECK(pensja>=1000),
ulica VARCHAR(40) NOT NULL
);

/* 2) Tabela: KURS */

/* Sprawdzanie czy istnieje tabela "Kurs" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Kurs')
DROP TABLE Kurs
GO

/* Tworzenie tabeli: KURS */

CREATE TABLE Kurs (
nr_kursu INT PRIMARY KEY,
dostêpnoœæ VARCHAR(40) NOT NULL,
data_i_czas_rozpoczêcia DATETIME NOT NULL,
data_i_czas_zakoñczenia DATETIME 
);

/* 3) Tabela: ZAPLECZE POJAZDÓW */

/* Sprawdzanie czy istnieje tabela "Zaplecze_pojazdów" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Zaplecze_pojazdów')
DROP TABLE Zaplecze_pojazdów
GO

/* Tworzenie tabeli: ZAPLECZE POJAZDÓW */

CREATE TABLE Zaplecze_pojazdów (
dostêpne_stanowisko INT IDENTITY(1,1) PRIMARY KEY,
stan VARCHAR(4) NOT NULL
);

/* 4) Tabela: POJAZD */

/* Sprawdzanie czy istnieje tabela "Pojazd" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Pojazd')
DROP TABLE Pojazd
GO

/* Tworzenie tabeli: POJAZD */

CREATE TABLE Pojazd (
nr_rejestracji VARCHAR(8) PRIMARY KEY,
id_kierowca INT NOT NULL REFERENCES Kierowca(id_kierowca),
nr_kursu INT NOT NULL REFERENCES Kurs(nr_kursu),
dostêpne_stanowisko INT NOT NULL REFERENCES Zaplecze_pojazdów(dostêpne_stanowisko),
marka VARCHAR(30) NOT NULL,
sprawnoœæ VARCHAR(10) NOT NULL,
liczba_miejsc INT NOT NULL,
kolor VARCHAR(30) NOT NULL,
nr_VIN VARCHAR(17) NOT NULL
);

/* 5) Tabela: UPRAWNIENIA */

/* Sprawdzanie czy istnieje tabela "Uprawnienia" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Uprawnienia')
DROP TABLE Uprawnienia
GO

/* Tworzenie tabeli: UPRAWNIENIA */

CREATE TABLE Uprawnienia (
id_kierowca INT NOT NULL REFERENCES Kierowca(id_kierowca),
nr_rejestracji VARCHAR(8) NOT NULL REFERENCES Pojazd(nr_rejestracji),
nr_kursu INT NOT NULL REFERENCES Kurs(nr_kursu),
dostêpne_stanowisko INT NOT NULL REFERENCES Zaplecze_pojazdów(dostêpne_stanowisko),
obecnoœæ VARCHAR(3) NOT NULL
);

/* 6) Tabela: KLIENT */

/* Sprawdzanie czy istnieje tabela "Klient" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Klient')
DROP TABLE Klient
GO

/* Tworzenie tabeli: KLIENT */

CREATE TABLE Klient (
id_klient INT IDENTITY(1,1) PRIMARY KEY,
imiê VARCHAR(40) NOT NULL CHECK(LEN(imiê)>2),
nazwisko VARCHAR(40) NOT NULL CHECK(LEN(nazwisko)>2),
telefon VARCHAR(9),
miejscowoœæ VARCHAR(50) NOT NULL CHECK(LEN(miejscowoœæ)>2),
nr_domu INT NOT NULL,
nr_lokalu INT,
kod_pocztowy CHAR(6) NOT NULL,
ulica VARCHAR(40)
);

/* 7) Tabela: UWAGI */

/* Sprawdzanie czy istnieje tabela "Uwagi" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Uwagi')
DROP TABLE Uwagi
GO

/* Tworzenie tabeli: UWAGI */

CREATE TABLE Uwagi (
dostêpne_stanowisko INT NOT NULL REFERENCES Zaplecze_pojazdów(dostêpne_stanowisko),
nr_kursu INT NOT NULL REFERENCES Kurs(nr_kursu),
id_kierowca INT NOT NULL REFERENCES Kierowca(id_kierowca),
nr_rejestracji VARCHAR(8) NOT NULL REFERENCES Pojazd(nr_rejestracji),
id_klient INT NOT NULL REFERENCES Klient(id_klient),
opis VARCHAR(255)
);

/* 8) Tabela: TOWAR */

/* Sprawdzanie czy istnieje tabela "Towar" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Towar')
DROP TABLE Towar
GO

/* Tworzenie tabeli: TOWAR */

CREATE TABLE Towar (
id_towar INT IDENTITY(1,1) PRIMARY KEY,
nazwa VARCHAR(40) NOT NULL,
jednostka_miary VARCHAR(20) NOT NULL,
cena_za_1_jm_brutto MONEY NOT NULL CHECK(cena_za_1_jm_brutto>0),
iloœæ INT NOT NULL,
cena MONEY NOT NULL CHECK(cena>0)
);

/* 9) Tabela: ZAMÓWIENIE */

/* Sprawdzanie czy istnieje tabela "Zamówienie" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Zamówienie')
DROP TABLE Zamówienie
GO

/* Tworzenie tabeli: ZAMÓWIENIE */

CREATE TABLE Zamówienie (
nr_zamówienia INT IDENTITY(1,1) PRIMARY KEY,
id_towar INT NULL REFERENCES Towar(id_towar), 
id_klient INT NULL REFERENCES Klient(id_klient),
data_z³o¿enia DATE 
);

/* 10) Tabela: US£UGA */

/* Sprawdzanie czy istnieje tabela "Us³uga" */

IF EXISTS (SELECT * FROM sys.tables WHERE name='Us³uga')
DROP TABLE Us³uga
GO

/* Tworzenie tabeli: US£UGA */

CREATE TABLE Us³uga (
id_us³uga INT IDENTITY(1,1) PRIMARY KEY,
nr_kursu INT NULL REFERENCES Kurs(nr_kursu),
id_towar INT NOT NULL REFERENCES Towar(id_towar),
nr_zamówienia INT NULL REFERENCES Zamówienie(nr_zamówienia),
id_klient INT NULL REFERENCES Klient(id_klient),
sk¹d VARCHAR(30) NULL,
dok¹d VARCHAR(30) NULL,
liczba_km INT NULL,
stawka_za_km MONEY NULL 
);

--#########################################################################################################################

--Polecenia INSERT:
/* 1) Wprowadzenie rekordów do tabeli: KIEROWCA */

INSERT INTO Kierowca (PESEL, imiê, nazwisko, miejscowoœæ, nr_domu, nr_lokalu, kod_pocztowy, telefon, data_zatrudnienia, pensja, ulica) VALUES
('87062300576','Damian','Krzychowski','Bieszkowice',18,6,'23-078','698242768','2009-04-23',3200,'Bia³ostocka'),
('64070321557','Emil','Pawlak','Wa³cz',8,NULL,'78-600','510567432','1993-05-12',4400,'Grabowa'),
('83112987903','Józef','Bramowicz','Miros³awiec',12,3,'78-650',NULL,'2001-07-15',2900,'Szkolna'),
('76101621907','Krystian','Nowak','Gdañsk',26,NULL,'25-050',NULL,'1998-02-23',5000,'Jesionowa'),
('90120187934','Dominik','Kowalski','Gdynia',105,36,'31-867','694768241','2011-08-31',1500,'Sienkiewicza'),
('70011093817','Adrian','Grzelak','Sopot',25,1,'81-459','768231059','1992-03-21',4000,'Czarnogórska');

/* 2) Wprowadzenie rekordów do tabeli: KURS */

INSERT INTO Kurs (nr_kursu, dostêpnoœæ, data_i_czas_rozpoczêcia,  data_i_czas_zakoñczenia) VALUES
('023072012','jest dostêpny','2012-07-10 08:00:00','2012-07-10 13:30:00'),
('031072012','nie jest dostêpny','2012-07-15 12:00:00',NULL),
('056072012','nie jest dostêpny','2012-07-16 14:45:00',NULL),
('072072012','jest dostêpny','2012-07-21 17:00:00','2012-07-22 06:00:00'),
('075072012','jest dostêpny','2012-07-23 05:00:00','2012-07-23 15:45:00'),
('084072012','nie jest dostêpny','2012-07-26 11:15:00',NULL);

/* 3) Wprowadzenie rekordów do tabeli: ZAPLECZE POJAZDÓW */

INSERT INTO Zaplecze_pojazdów (stan) VALUES
('TAK'),
('TAK'),
('NIE'),
('NIE'),
('NIE'),
('TAK');

/* 4) Wprowadzenie rekordów do tabeli: POJAZD */

INSERT INTO Pojazd (nr_rejestracji, id_kierowca, nr_kursu, dostêpne_stanowisko, marka, sprawnoœæ, liczba_miejsc, kolor, nr_VIN) VALUES
('GDA543L0',1,'023072012',2,'MERCEDES 53487','jest',6,'srebrny','ASD548650IOTIY856'),
('GBY78U22',4,'075072012',6,'SCANIA 78234','jest',6,'bia³y','SB5869230ERD09741'),
('CTR6720A',6,'031072012',3,'RENAULT 94671','jest',5,'czarny','WNI739310683HRQ86'),
('ZKO54BN1',3,'084072012',5,'BMW 76219','jest',5,'purpurowy','QSY933002175583UJ'),
('GWE63771',5,'056072012',4,'VOLVO 11209','jest',7,'granatowy','PWE8821267345WQV0'),
('GSL94UY3',2,'072072012',1,'MAGNUM 52183','jest',5,'zielony','SFD52791732004EZA');

/* 5) Wprowadzenie rekordów do tabeli: UPRAWNIENIA */

INSERT INTO Uprawnienia (id_kierowca, nr_rejestracji, nr_kursu, dostêpne_stanowisko, obecnoœæ) VALUES
(1,'GDA543L0','023072012',2,'TAK'),
(3,'ZKO54BN1','084072012',5,'NIE'),
(4,'GBY78U22','075072012',6,'TAK'),
(2,'GSL94UY3','072072012',1,'NIE'),
(5,'GWE63771','056072012',4,'TAK'),
(6,'CTR6720A','031072012',3,'NIE');

/* 6) Wprowadzenie rekordów do tabeli: KLIENT */

INSERT INTO Klient (imiê, nazwisko, telefon, miejscowoœæ, nr_domu, nr_lokalu, kod_pocztowy, ulica) VALUES
('Edward','Skrzetuski','697213793','Bia³ystok',19,2,'78-245','Gdañska'),
('Joanna','Nowo¿elska',NULL,'Warszawa',126,NULL,'00-300','G³ówna'),
('Ma³gorzata','Bobryk','507123951','Gdañsk',36,NULL,'23-916','Tropikalna'),
('Janusz','Kolabski',NULL,'Toruñ',7,4,'66-745','Reja'),
('Elwira','PaŸdzioch','503267834','Bydgoszcz',98,16,'15-832','Zamostna'),
('Tadeusz','Skrzypkowski','500829174','Szczecin',78,NULL,'90-825','Wrzosowa');

/* 7) Wprowadzenie rekordów do tabeli: UWAGI */

INSERT INTO Uwagi (dostêpne_stanowisko, nr_kursu, id_kierowca, nr_rejestracji, id_klient, opis) VALUES
(2,'023072012',1,'GDA543L0',3,'nastêpnym razem przyje¿d¿aæ w godzinach popo³udniowych'),
(1,'072072012',2,'GSL94UY3',1,'zamówienia bêd¹ dostarczane tylko przez tego kierowcê'),
(5,'084072012',3,'ZKO54BN1',2,NULL),
(6,'075072012',4,'GBY78U22',5,'dostawa by³a spóŸniona'),
(4,'056072012',5,'GWE63771',4,NULL),
(3,'031072012',6,'CTR6720A',6,NULL);

/* 8) Wprowadzenie rekordów do tabeli: TOWAR */

INSERT INTO Towar (nazwa, jednostka_miary, cena_za_1_jm_brutto, iloœæ, cena) VALUES
('Pralka BEKO A8621','szt.',1299,1,1299),
('Telewizor SAMSUNG TE784','szt.',1500,1,1500),
('Karma dla psa CHAPPY','kg',6.30,30,189),
('Karta pamiêci SD CARD 16GB','szt.',49,15,735),
('Drzwi PORTA antyw³amaniowe AW287','szt.',300,6,1800);

/* 9) Wprowadzenie rekordów do tabeli: ZAMÓWIENIE */

INSERT INTO Zamówienie (id_towar, id_klient, data_z³o¿enia) VALUES
(NULL,NULL,NULL),
(NULL,NULL,NULL),
(1,5,'2012-07-20'),
(3,1,'2012-07-15'),
(4,3,'2012-07-03'),
(NULL,NULL,NULL);

/* 10) Wprowadzenie rekordów do tabeli: US£UGA */

INSERT INTO Us³uga (nr_kursu, id_towar, nr_zamówienia, id_klient, sk¹d, dok¹d, liczba_km, stawka_za_km) VALUES
(NULL,2,NULL,NULL,NULL,NULL,NULL,NULL),
('075072012',1,3,5,'Wejherowo','Bydoszcz',300,2),
('023072012',4,5,3,'Wejherowo','Gdañsk',45,3.20),
('072072012',3,4,1,'Wejherowo','Bia³ystok',400,5),
(NULL,5,NULL,NULL,NULL,NULL,NULL,NULL);

--#########################################################################################################################
--#########################################################################################################################


-- PROJEKT 3: SKRYPT:

--1) WIDOK 1
/* Sprawdzanie, czy istnieje widok "Lista_sta³ych_klientów" */

IF EXISTS (SELECT * FROM sys.views WHERE name = 'Lista_sta³ych_klientów')
DROP VIEW Lista_sta³ych_klientów;
GO

/* Tworzenie widoku, który przechowuje dane na temat klientów, którzy mieszkaj¹ najbli¿ej firmy i s¹ sta³ymi klientami, 
a ich kierowcy wyje¿d¿aj¹ z Wejherowa */

CREATE VIEW Lista_sta³ych_klientów
AS
SELECT kl.id_klient, kl.imiê, kl.nazwisko, kl.miejscowoœæ, SUM(kl.nr_domu) AS licznik_nr_domów, kl.ulica, kl.kod_pocztowy, u.opis, 
	   t.nazwa, t.jednostka_miary, t.iloœæ, t.cena, us.sk¹d FROM Klient kl FULL JOIN Uwagi u
	ON kl.id_klient=u.id_klient JOIN Towar t
		ON u.id_klient=t.id_towar JOIN Us³uga us
			ON kl.id_klient=us.id_klient
	GROUP BY kl.id_klient, kl.imiê, kl.nazwisko, kl.miejscowoœæ, kl.ulica, kl.kod_pocztowy, u.opis, t.nazwa,
		     t.jednostka_miary, t.iloœæ, t.cena, us.sk¹d
HAVING SUM(kl.nr_domu)<(SELECT AVG(nr_domu) FROM Klient);
GO

/* Przyk³adowe wywo³anie widoku "Lista_sta³ych_klientów" z u¿yciem instrukcji CASE */

SELECT CASE WHEN id_klient<4 THEN 'Tak. Wystêpuje w wyœwietlonym widoku' 
			ELSE 'Nie. Nie wystêpuje w wyœwietlonym widoku'
	   END AS 'Czy wystêpuj¹ klienci poni¿ej id_klient 4 ?', * 
FROM Lista_sta³ych_klientów
GO
		

--2) WIDOK 2
/* Sprawdzanie, czy istnieje widok "Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym" */

IF EXISTS (SELECT * FROM sys.views WHERE name = 'Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym')
DROP VIEW Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym;
GO

/* Tworzenie widoku, który przechowuje dane temat kierowców, którzy posiadaj¹ wiêcej ni¿ podstawow¹ liczbê miejsc w pojeŸdzie oraz 
ich klientów, do których maksymalna odleg³oœæ jest równa 400 km */

CREATE VIEW Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym 
AS 
SELECT k.id_kierowca, k.imiê AS imiona_kierowców, k.nazwisko AS nazwiska_kierowców, k.data_zatrudnienia, k.pensja, zp.stan, 
	   p.marka, SUM(p.liczba_miejsc) AS liczba_miejsc_powy¿ej_5, p.kolor, kl.imiê, kl.nazwisko, kl.miejscowoœæ, z.data_z³o¿enia, 
	   t.nazwa, t.iloœæ, t.cena, u.sk¹d, MAX(u.liczba_km) AS max_liczba_km, u.stawka_za_km
FROM Kierowca k LEFT JOIN Zaplecze_pojazdów zp
	ON k.id_kierowca=zp.dostêpne_stanowisko LEFT JOIN Pojazd p
		ON k.id_kierowca=p.id_kierowca RIGHT JOIN Klient kl 
			ON k.id_kierowca=kl.id_klient LEFT JOIN Zamówienie z
				ON k.id_kierowca=z.nr_zamówienia LEFT JOIN Towar t
					ON k.id_kierowca=t.id_towar LEFT JOIN Us³uga u
						ON k.id_kierowca=u.id_us³uga
	GROUP BY k.id_kierowca, k.imiê, k.nazwisko, k.data_zatrudnienia, k.pensja, zp.stan, p.marka,  
			 p.kolor, kl.imiê, kl.nazwisko, kl.miejscowoœæ, z.data_z³o¿enia, t.nazwa, t.iloœæ, t.cena, u.sk¹d, 
			 u.stawka_za_km
HAVING SUM(p.liczba_miejsc)>(SELECT AVG(liczba_miejsc) FROM Pojazd);
GO

/* Przyk³adowe wywo³anie widoku "Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym" */

SELECT id_kierowca, imiona_kierowców, nazwiska_kierowców, data_zatrudnienia, pensja, stan, marka, liczba_miejsc_powy¿ej_5, 
	   kolor, miejscowoœæ, data_z³o¿enia, nazwa, iloœæ, cena, sk¹d, max_liczba_km, stawka_za_km
FROM Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym 
ORDER BY nazwiska_kierowców DESC; 
GO


--3) FUNKCJA 1
/* Sprawdzanie, czy istnieje funkcja "sprawdz_pensja" */

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' and name = 'sprawdz_pensja')
DROP FUNCTION dbo.sprawdz_pensja;
GO

/* Tworzenie funkcji z parametrem, która po podaniu kwoty porównuje j¹ ze œredni¹ pensj¹ kierowców i po wywo³aniu wypisuje 
odpowiedni komunikat */

CREATE FUNCTION sprawdz_pensja (@liczba MONEY)
RETURNS VARCHAR(255)
BEGIN
	 DECLARE @napis VARCHAR(255)
	 SET @napis = CASE
		 
		 WHEN @liczba=(SELECT AVG(pensja) FROM Kierowca) THEN 'Tyle wynosi œrednia pensja kierowców'
		 
		 WHEN @liczba<(SELECT AVG(pensja) FROM Kierowca) THEN 'Podana pensja jest mniejsza od œredniej pensji kierowców'
		 
		 ELSE 'Podana pensja jest wiêksza od œredniej pensji kierowców'
	 END
	 RETURN @napis
END
GO

/* Przyk³adowe wywo³anie funkcji "sprawdz_pensja" */

SELECT dbo.sprawdz_pensja(2900)
GO


--4) FUNKCJA 2
/* Sprawdzanie, czy istnieje funkcja "konwersja_napisów" */

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' and name = 'konwersja_napisow')
DROP FUNCTION dbo.konwersja_napisow;
GO

/* Tworzenie funkcji z parametrem, która po podaniu towaru, sprawdza czy istnieje w bazie i jeœli tak to zamienia du¿e litery na 
ma³e i po wywo³aniu wypisuje skonwertowany napis	w przeciwnym wypadku zwraca odpowiedni komunikat */

CREATE FUNCTION konwersja_napisow (@napis VARCHAR(120))
RETURNS VARCHAR(255)
BEGIN
	 DECLARE @informacja_zwrotna VARCHAR(255)
	 IF (@napis=(SELECT nazwa FROM Towar WHERE id_towar=1) 
	  OR @napis=(SELECT nazwa FROM Towar WHERE id_towar=2)
	  OR @napis=(SELECT nazwa FROM Towar WHERE id_towar=3)
	  OR @napis=(SELECT nazwa FROM Towar WHERE id_towar=4)
	  OR @napis=(SELECT nazwa FROM Towar WHERE id_towar=5))
	 SET @informacja_zwrotna = (LOWER(@napis)) 
	 
	 ELSE SET @informacja_zwrotna = 'Podany przez ciebie towar nie istnieje w bazie danych'
	 RETURN @informacja_zwrotna
END
GO

/* Przyk³adowe wywo³anie funkcji "konwersja_napisow" */

SELECT dbo.konwersja_napisow('Karma dla psa CHAPPY') AS nazwa_towaru_po_konwersacji;
GO


--5) FUNKCJA 3
/* Sprawdzanie, czy istnieje funkcja "staz_pracy_pracownika_w_firmie" */

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'TF' and name = 'staz_pracy_pracownika_w_firmie')
DROP FUNCTION dbo.staz_pracy_pracownika_w_firmie;
GO

/* Tworzenie funkcji z 2 parametrami, która po podaniu imienia i daty zatrudnienia kierowcy, sprawdza czy istnieje w bazie i 
jeœli tak to po wywo³aniu wypisuje sta¿ pracy kierowcy w firmie z dok³adnoœci¹ do lat, miesiêcy i dni w przeciwnym wypadku 
zwraca same NULLe */

CREATE FUNCTION staz_pracy_pracownika_w_firmie (@imie VARCHAR(50), @data_zatrudnienia DATE)
RETURNS @tab_staz_pracy TABLE (lp INT, lat INT, miesiêcy INT, dni INT)
AS
BEGIN
	 DECLARE @tab TABLE (id_kierowca INT PRIMARY KEY, imiê VARCHAR(40), nazwisko VARCHAR(40), data_zatrudnienia DATE)
	 INSERT INTO @tab SELECT id_kierowca, imiê, nazwisko, data_zatrudnienia FROM Kierowca
	 DECLARE @lat INT, @miesiêcy INT, @dni INT
	 SET @lat = (SELECT DATEDIFF(YY, @data_zatrudnienia, GETDATE())) 
	 SET @miesiêcy = (SELECT	DATEDIFF(MM, @data_zatrudnienia, GETDATE()))
	 SET @dni = (SELECT	DATEDIFF(DD, @data_zatrudnienia, GETDATE())) 
		   IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=1)) 
		      AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=1)))
		   INSERT INTO @tab_staz_pracy VALUES (1, @lat, @miesiêcy, @dni)
		   
		   ELSE IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=2)) 
		           AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=2)))
		   INSERT INTO @tab_staz_pracy VALUES (2, @lat, @miesiêcy, @dni)
		   
		   ELSE IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=3)) 
		           AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=3)))
		   INSERT INTO @tab_staz_pracy VALUES (3, @lat, @miesiêcy, @dni)
		   
		   ELSE IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=4)) 
		           AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=4)))
		   INSERT INTO @tab_staz_pracy VALUES (4, @lat, @miesiêcy, @dni)
		   
		   ELSE IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=5)) 
		           AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=5)))
		   INSERT INTO @tab_staz_pracy VALUES (5, @lat, @miesiêcy, @dni)
		   
		   ELSE IF ((@imie = (SELECT imiê FROM @tab WHERE id_kierowca=6)) 
		           AND (@data_zatrudnienia = (SELECT data_zatrudnienia FROM @tab WHERE id_kierowca=6)))
		   INSERT INTO @tab_staz_pracy VALUES (6, @lat, @miesiêcy, @dni)
		   
		   ELSE INSERT INTO @tab_staz_pracy VALUES (NULL, NULL, NULL, NULL)
	 RETURN 
END
GO
 
/* Przyk³adowe wywo³anie funkcji "staz_pracy_pracownika_w_firmie" */

SELECT k.id_kierowca, k.imiê, k.nazwisko, k.data_zatrudnienia, sp.lat, sp.miesiêcy, sp.dni 
FROM Kierowca k JOIN dbo.staz_pracy_pracownika_w_firmie ('Krystian','1998-02-23')sp
ON k.id_kierowca=sp.lp
ORDER BY k.imiê ASC
GO


--6) FUNKCJA 4
/* Sprawdzanie, czy istnieje funkcja "wyluskacz_id" */

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'FN' and name = 'wyluskacz_id')
DROP FUNCTION dbo.wyluskacz_id;
GO

/* Tworzenie funkcji z 2 parametrami, która po podaniu imienia i miejscowoœci zamieszkania klienta, sprawdza czy istnieje w 
bazie i jeœli tak to po wywo³aniu zwraca jego nr id obliczaj¹c funkcjê matematyczn¹, która siê jemu równa w przeciwnym wypadku 
zwraca NULL */
 
CREATE FUNCTION wyluskacz_id (@imiê VARCHAR(50), @miejscowoœæ VARCHAR(50))
RETURNS INT
BEGIN
	 DECLARE @id_klient INT
	 IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='78-245') 
	    AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE '%ñ%'))
	 SET @id_klient = (SELECT COS(0))
	 
	 ELSE IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='00-300') 
	         AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE '%ó%'))
	 SET @id_klient = (SELECT FLOOR(2.9)) 
	 
	 ELSE IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='23-916') 
	         AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE '%pik%'))
	 SET @id_klient = (SELECT SQRT(1)+SQRT(1)+SQRT(1)) 
	 
	 ELSE IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='66-745') 
	         AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE 'Rej%'))
	 SET @id_klient = (SELECT SIGN(256)*SQRT(16))
	 
	 ELSE IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='15-832') 
	         AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE '%most%'))
	 SET @id_klient = (SELECT SQRT(625)/SQRT(25))
	 
	 ELSE IF (@imiê = (SELECT imiê FROM Klient WHERE kod_pocztowy='90-825') 
	         AND @miejscowoœæ = (SELECT miejscowoœæ FROM Klient WHERE ulica LIKE '%sowa'))
	 SET @id_klient = (SELECT ABS(SQRT(36)))
	 
	 ELSE SET @id_klient = NULL
	 RETURN @id_klient 
END
GO

/* Przyk³adowe wywo³anie funkcji "wy³uskacz_id" */

SELECT dbo.wyluskacz_id ('Elwira', 'Bydgoszcz') AS id_klient;
GO


--7) PROCEDURA 1
/* Sprawdzanie czy istnieje procedura "wprowadz_nowy_kierowca_i_jego_kurs" */

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'wprowadz_nowy_kierowca_i_jego_kurs')
DROP PROC wprowadz_nowy_kierowca_i_jego_kurs;
GO

/* Tworzenie procedury z parametrami, która wprowadza dane nowego kierowcy oraz rozpoczêtego przez niego nowego kursu oraz
modyfikacjê zmian w zapleczu pojadów */

CREATE PROC wprowadz_nowy_kierowca_i_jego_kurs
	   @id_kierowca INT ,@PESEL CHAR(11), @imiê VARCHAR(40), @nazwisko VARCHAR(40), @miejscowoœæ VARCHAR(50), @ulica VARCHAR(40), 
	   @nr_domu INT, @nr_lokalu INT, @kod_pocztowy CHAR(6), @telefon VARCHAR(9), @pensja MONEY, @data_zatrudnienia DATE, 
	   @nr_kursu INT, @data_i_czas_rozpoczêcia DATETIME, @dostêpnoœæ VARCHAR(40), @data_i_czas_zakoñczenia DATETIME, 
	   @dostêpne_stanowisko INT, @stan VARCHAR(4)
AS		
	   SET IDENTITY_INSERT Kierowca ON
	   INSERT INTO Kierowca (id_kierowca, PESEL, imiê, nazwisko, miejscowoœæ, ulica, nr_domu, nr_lokalu, kod_pocztowy, telefon, 
							 pensja, data_zatrudnienia)
	   VALUES (@id_kierowca, @PESEL, @imiê, @nazwisko, @miejscowoœæ, @ulica, @nr_domu, @nr_lokalu, @kod_pocztowy, @telefon, 
			   @pensja, @data_zatrudnienia)
	   SET IDENTITY_INSERT Kierowca OFF
		
	   
	   INSERT INTO Kurs (nr_kursu, data_i_czas_rozpoczêcia, dostêpnoœæ, data_i_czas_zakoñczenia)
	   VALUES (@nr_kursu, @data_i_czas_rozpoczêcia, @dostêpnoœæ, @data_i_czas_zakoñczenia)
	   
	   SET IDENTITY_INSERT Zaplecze_pojazdów ON
	   INSERT INTO Zaplecze_pojazdów (dostêpne_stanowisko, stan)
	   VALUES (@dostêpne_stanowisko, @stan)
	   SET IDENTITY_INSERT Zaplecze_pojazdów OFF
GO

/* Przyk³adowe wywo³anie procedury "wprowadz_nowy_kierowca_i_jego_kurs" */

EXEC wprowadz_nowy_kierowca_i_jego_kurs 7,'58042599076','Zdzis³aw','Szalowski','S³upsk','Kasztanowa',15,8,'76-200','503098723',
										  5200,'2012-05-12','87082012','2012-08-16 08:00:00','nie jest dostêpny',NULL,
										  7,'NIE'
GO

SELECT k.id_kierowca, k.PESEL, k.imiê, k.nazwisko, k.miejscowoœæ, k.ulica, k.nr_domu, k.nr_lokalu, k.kod_pocztowy, k.telefon, 
	   k.pensja, k.data_zatrudnienia, zp.stan
	   FROM Kierowca k JOIN Zaplecze_pojazdów zp
	   ON k.id_kierowca=zp.dostêpne_stanowisko
SELECT * FROM Kurs
GO
	  
	   
--8) PROCEDURA 2
/* Sprawdzanie czy istnieje procedura "zwiêksz_pensja_i_iloœæ" */

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'zwiêksz_pensja_i_iloœæ')
DROP PROC zwiêksz_pensja_i_iloœæ;
GO

/* Tworzenie procedury z parametrami, która zwiêksza pensjê kierowcy o 20% i iloœæ konkretnego towaru o œredni¹ iloœæ wszystkich
towarów */

CREATE PROC zwiêksz_pensja_i_iloœæ
	   @id_kierowca INT, @id_towar INT, @nowa_pensja MONEY OUTPUT, @nowa_iloœæ INT OUTPUT, @liczba_proc FLOAT=20 
AS
BEGIN
	 DECLARE @sr_iloœæ INT
	 SET @sr_iloœæ=(SELECT AVG(iloœæ) FROM Towar)
	 
	 DECLARE @procent FLOAT
	 SET @procent=(@liczba_proc/100)+1
	 
	 SELECT @nowa_pensja=pensja*@procent
	 FROM Kierowca
	 WHERE id_kierowca=@id_kierowca
	 UPDATE Kierowca
	 SET pensja=@nowa_pensja
	 WHERE id_kierowca=@id_kierowca
	 
	 SELECT @nowa_iloœæ=iloœæ+@sr_iloœæ
	 FROM Towar
	 WHERE id_towar=@id_towar
	 UPDATE Towar
	 SET iloœæ=@nowa_iloœæ
	 WHERE id_towar=@id_towar
END
GO

/* Przyk³adowe wywo³anie procedury "zwiêksz_pensja_i_iloœæ" */

DECLARE @n_pensja MONEY, @n_iloœæ INT
EXEC zwiêksz_pensja_i_iloœæ 1,1, @n_pensja OUTPUT, @n_iloœæ OUTPUT
GO

SELECT k.id_kierowca, k.imiê, nazwisko, k.pensja FROM Kierowca k WHERE id_kierowca=1
SELECT t.nazwa, t.iloœæ FROM Towar t WHERE id_towar=1
GO


--9) PROCEDURA 3

/* Sprawdzanie czy istnieje procedura "wypisz_lata_zatrud" */
	
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'wypisz_lata_zatrud')
DROP PROC wypisz_lata_zatrud;
GO				

/* Tworzenie procedury z parametrem, która po okreœlonym wywo³aniu, czyli podaniu roku zatrudnienia wypisuje rok zatrudnienia
kierowców, które w zale¿noœci od podanego przez u¿ytkownika roku wiêksze b¹dŸ mniejsze od œredniego roku zatrudnienia kierowców */

CREATE PROC wypisz_lata_zatrud
	   @rok_zatr INT
AS
BEGIN
	 DECLARE @œredni_rok_zatr INT
	 SET @œredni_rok_zatr=(SELECT AVG(YEAR(data_zatrudnienia)) FROM Kierowca)
	 
	 IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
					WHERE id_kierowca=1) AND @rok_zatr>@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)>@œredni_rok_zatr
	 ORDER BY nazwisko, imiê 
	 
	 ELSE IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
						 WHERE id_kierowca=2) AND @rok_zatr<@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)<@œredni_rok_zatr
	 ORDER BY nazwisko, imiê
	 
	 ELSE IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
						 WHERE id_kierowca=3) AND @rok_zatr<@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)<@œredni_rok_zatr
	 ORDER BY nazwisko, imiê
	 
	 ELSE IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
						 WHERE id_kierowca=4) AND @rok_zatr<@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)<@œredni_rok_zatr
	 ORDER BY nazwisko, imiê
	 
	 ELSE IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
						 WHERE id_kierowca=5) AND @rok_zatr>@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)>@œredni_rok_zatr
	 ORDER BY nazwisko, imiê
	 
	 ELSE IF (@rok_zatr=(SELECT YEAR(data_zatrudnienia) FROM Kierowca
						 WHERE id_kierowca=6) AND @rok_zatr<@œredni_rok_zatr)
	 SELECT imiê, nazwisko, YEAR(data_zatrudnienia) AS rok_zatrudnienia
	 FROM Kierowca
	 WHERE YEAR(data_zatrudnienia)<@œredni_rok_zatr
	 ORDER BY nazwisko, imiê
END
GO

/* Przyk³adowe wywo³anie procedury "wypisz_lata_zatrud" */

EXEC wypisz_lata_zatrud 2009 


--10) PROCEDURA 4

/* Sprawdzanie czy istnieje procedura "pow_cena_i_wyp_nazw" */

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'pow_cena_i_wyp_nazw')
DROP PROC pow_cena_i_wyp_nazw;
GO	

/* Tworzenie procedury z parametrami, która przy wywo³aniu, czyli podaniu id towaru, jego ceny oraz id klienta, dodaje do tej 
ceny œredni¹ wartoœæ ceny towarów oraz wyœwietla na podstawie id klienta nazwiska które s¹ mniejsze, wiêksze b¹dŸ równe œredniej 
d³ugoœci nazwiska klienta */

CREATE PROC pow_cena_i_wyp_nazw
	   @id_towar INT, @cena_t MONEY, @id_klient INT  
AS
BEGIN
	 DECLARE @œr_cena_t MONEY, @nowa_cena_t MONEY, @œr_d³_nazwiska INT
			 
	 SET @œr_cena_t=(SELECT AVG(cena) FROM Towar)
	 SET @œr_d³_nazwiska=(SELECT AVG(LEN(nazwisko)) FROM Klient)
	 
	 BEGIN
	 SET @cena_t=(SELECT cena FROM Towar WHERE id_towar=@id_towar)
	 SET @nowa_cena_t=(@cena_t+@œr_cena_t)
	 UPDATE Towar 
	 SET cena=@nowa_cena_t 
	 WHERE id_towar=@id_towar
	 END
	 
	 BEGIN
	 IF (@id_klient=(SELECT id_klient FROM Klient WHERE id_klient=3)
	 OR  @id_klient=(SELECT id_klient FROM Klient WHERE id_klient=4))
	 SELECT imiê, nazwisko, LEN(nazwisko) AS d³ugoœæ_nazwiska FROM Klient
	 WHERE LEN(nazwisko)<@œr_d³_nazwiska
	 ORDER BY nazwisko
	 
	 ELSE IF (@id_klient=(SELECT id_klient FROM Klient WHERE id_klient=1)
		  OR  @id_klient=(SELECT id_klient FROM Klient WHERE id_klient=2)
		  OR  @id_klient=(SELECT id_klient FROM Klient WHERE id_klient=6)															)
	 SELECT imiê, nazwisko, LEN(nazwisko) AS d³ugoœæ_nazwiska FROM Klient
	 WHERE LEN(nazwisko)>@œr_d³_nazwiska
	 ORDER BY nazwisko
	 
	 ELSE 
	 SELECT imiê, nazwisko, LEN(nazwisko) AS d³ugoœæ_nazwiska FROM Klient
	 WHERE LEN(nazwisko)=@œr_d³_nazwiska
	 ORDER BY nazwisko
	 END
END
GO

/* Przyk³adowe wywo³anie procedury "pow_cena_i_wyp_nazw" */

EXEC pow_cena_i_wyp_nazw 1,735,4
SELECT nazwa, cena FROM Towar 
GO


--11) WYZWALACZ 1

/* Sprawdzanie czy istnieje wyzwalacz "zm_zam_tow" */

IF EXISTS (SELECT * FROM sys.triggers WHERE name='zm_zam_tow')
DROP TRIGGER zm_zam_tow;
GO

/* Tworzenie wyzwalacza z u¿yciem kursora, który po uprzednim przygotowaniu dla niego widoku dotycz¹cego zamówionych towarów, 
zmienia dane zamówionego wczeœniej towaru i wypisuje odpowiedni komunikat */

--przygotowany widok dla wyzwalacza
IF EXISTS (SELECT * FROM sys.views WHERE name = 'zamówione_towary')
DROP VIEW zamówione_towary;
GO

CREATE VIEW zamówione_towary
AS
  SELECT t.id_towar, t.nazwa, t.jednostka_miary, t.iloœæ, t.cena, z.data_z³o¿enia
  FROM Towar t LEFT JOIN Zamówienie z
  ON t.id_towar=z.id_towar
GO

--wyzwalacz
CREATE TRIGGER zm_zam_tow ON zamówione_towary
INSTEAD OF UPDATE
AS
BEGIN
	 DECLARE zm_w_widoku CURSOR
	 FOR SELECT id_towar, nazwa, jednostka_miary, iloœæ, cena 
	 FROM inserted
	 DECLARE @id INT, @nazwa VARCHAR(40), @jednostka_miary VARCHAR(20), @iloœæ INT, @cena MONEY
			 
	 OPEN zm_w_widoku
	 FETCH NEXT FROM zm_w_widoku INTO @id, @nazwa, @jednostka_miary, @iloœæ, @cena 
	 
	 WHILE @@FETCH_STATUS=0
	 BEGIN 
	 UPDATE Towar SET nazwa=@nazwa, jednostka_miary=@jednostka_miary, iloœæ=@iloœæ, cena=@cena
	 WHERE id_towar=@id
	 
	 PRINT 'Zmieniono nazwê w widoku na: ' +@nazwa
	 PRINT 'Zmieniono jednostkê miary w widoku na: ' +@jednostka_miary
	 PRINT 'oraz pozosta³e zwi¹zane z tym towarem dane.' 
	 
	 FETCH NEXT FROM zm_w_widoku INTO @id, @nazwa, @jednostka_miary, @iloœæ, @cena 
	 END
	 
	 CLOSE zm_w_widoku
	 DEALLOCATE zm_w_widoku
END
GO

/* Przyk³adowe wywo³anie wyzwalacza "zm_zam_tow" na potrzebnym do niego widoku "zamówione_towary" */
	
UPDATE zamówione_towary SET nazwa='Lodówka AMICON WE770', jednostka_miary='szt.', iloœæ=21, cena=15750
WHERE id_towar=1
SELECT * FROM zamówione_towary
GO

--wy³¹czenie wyzwalacza "usun_1_kierowce" po pomyœlnym wywo³aniu
ALTER VIEW zamówione_towary DISABLE TRIGGER zm_zam_tow
GO


--12) WYZWALACZ 2

/* Sprawdzanie czy istnieje wyzwalacz "usun_1_kierowce" */

IF EXISTS (SELECT * FROM sys.triggers WHERE name='usun_1_kierowce')
DROP TRIGGER usun_1_kierowce;
GO

/* Tworzenie wyzwalacza z u¿yciem kursora, który usuwa 1 kierowcê po wywo³aniu i informuje u¿ytkowika o tym, potwierdzaj¹c to
imieniem i nazwiskiem uuniêtego kierowcy  */

CREATE TRIGGER usun_1_kierowce ON Kierowca
AFTER DELETE
AS 
BEGIN
	 DECLARE kursor_usuñ CURSOR
	 FOR SELECT imiê, nazwisko FROM deleted
	 DECLARE @imiê VARCHAR(40), @nazwisko VARCHAR(50)
	 
	 OPEN kursor_usuñ
	 FETCH NEXT FROM kursor_usuñ INTO @imiê, @nazwisko
	 
	 WHILE @@FETCH_STATUS=0
	 BEGIN
	 
	 PRINT 'Usuniêto: '+@imiê+' '+ @nazwisko
	 
	 FETCH NEXT FROM kursor_usuñ INTO @imiê, @nazwisko
	 END
	 
	 CLOSE kursor_usuñ
	 DEALLOCATE kursor_usuñ
END
GO

/* Przyk³adowe wywo³anie wyzwalacza "usun_1_kierowce" */

DELETE FROM Kierowca WHERE id_kierowca=7
GO

--wy³¹czenie wyzwalacza "usun_1_kierowce" po pomyœlnym wywo³aniu
ALTER TABLE Kierowca DISABLE TRIGGER usun_1_kierowce
GO


--13) WYZWALACZ 3

/* Sprawdzanie czy istnieje wyzwalacz "zak_klient_wpr" */

IF EXISTS (SELECT * FROM sys.triggers WHERE name='zak_klient_wpr')
DROP TRIGGER zak_klient_wpr;
GO

/* Tworzenie wyzwalacza, który po odpowiednim wywo³aniu, czyli wprowadzeniu nowego klienta z nr domu powy¿ej 130 i nr lokalu 
powy¿ej 20 zapobiega wprowadzeniu tego rekordu i wyœwietla odpowiedni komunikat */

CREATE TRIGGER zak_klient_wpr ON Klient
AFTER INSERT
AS
BEGIN
	 DECLARE @nr_domu INT, @nr_lokalu INT
	 SELECT @nr_domu=nr_domu FROM inserted 
	 SELECT @nr_lokalu=nr_lokalu FROM inserted  
	 
	 IF @nr_domu>130 AND @nr_lokalu>20
	 BEGIN
	 PRINT ('¯¹dane wprowdzenie rekordu siê nie powiod³o')
	 RAISERROR ('Nie mo¿na podaæ nr domu wiêkszego od 130 i lokalu wiêkszego od 20',1,2) WITH NOWAIT
	 ROLLBACK
	 END
END
GO

/* Przyk³adowe wywo³anie wyzwalacza "zak_klient_wpr" */

INSERT INTO Klient(imiê, nazwisko, telefon, miejscowoœæ, nr_domu, nr_lokalu, kod_pocztowy, ulica) VALUES
('Helena', 'Bogacka', '512675982', 'Koœcierzyna', 145, 27, '67-091', 'D³uga')
SELECT * FROM Klient
GO

--wy³¹czenie wyzwalacza "zak_klient_wpr" po pomyœlnym wywo³aniu
ALTER TABLE Klient DISABLE TRIGGER zak_klient_wpr
GO

--14) WYZWALACZ 4

/* Sprawdzanie czy istniej¹ wyzwalacze: "wpr_nkier" i "us_nkier" */

IF EXISTS (SELECT * FROM sys.triggers WHERE name='wpr_nkier')
IF EXISTS (SELECT * FROM sys.triggers WHERE name='us_nkier')
DROP TRIGGER wpr_nkier 
DROP TRIGGER us_nkier
GO

/* Tworzenie 2 krótkich wyzwalaczy, które po wywo³aniu ,1 zadania wsadowego maj¹cy jednoczeœnie polecenia insert i delete 
1 rekordu, dzia³aj¹ po sobie w tabeli Kierowca  */
 
CREATE TRIGGER wpr_nkier ON Kierowca
AFTER INSERT
AS
BEGIN
	  
	 SELECT 'Wiersz dodany:'
	 SELECT * FROM inserted
END
GO
CREATE TRIGGER us_nkier ON Kierowca
AFTER DELETE
AS
BEGIN 
	 SELECT 'Wiersz usuniêty:'
	 SELECT * FROM deleted
END
GO

/* Przyk³adowe wywo³anie wyzwalaczy: "wpr_nkier" i "us_nkier" */

INSERT INTO Kierowca (PESEL, imiê, nazwisko, miejscowoœæ, nr_domu, nr_lokalu, kod_pocztowy, telefon, data_zatrudnienia, pensja,
					  ulica) VALUES
('72061885673', 'Karol', 'Œwi¹tek', 'Wejherowo', 24, 2, '84-200', '697854210', '2012-06-05', 2500, 'Traugutta')
DELETE FROM Kierowca WHERE imiê='Karol'
SELECT * FROM Kierowca
GO

--wy³¹czenie wyzwalaczy "wpr_nkier" i "us_nkier" po pomyœlnym wywo³aniu
ALTER TABLE Kierowca DISABLE TRIGGER wpr_nkier
ALTER TABLE Kierowca DISABLE TRIGGER us_nkier
GO


--15) PIVOT 1

/* Wyœwietlenie tabeli przestawnej, która pokazuje imiê i nazwisko kierowców oraz ich pensjê wed³ug d³ugoœci ich imienia */

SELECT imiê, nazwisko, [4] AS '4-literowe', [5] AS '5-literowe', [6] AS '6-literowe', [7] AS '7-literowe',
	   [8] AS '8-literowe' 
FROM
	(SELECT imiê, nazwisko, LEN(imiê) AS d³_imienia, pensja
	 FROM Kierowca
	) tabela1
PIVOT 
	(
	SUM(pensja) 
	FOR d³_imienia IN ([4], [5], [6], [7], [8])
	) AS pv1
ORDER BY imiê, nazwisko
GO


--16) PIVOT 2

/* Wyœwietlenie tabeli przestawnej, która pokazuje nazwê towarów, dane zwi¹zane z us³ug¹ tych towarów oraz cenê towarów na 
podstawie d³ugoœci cyfr iloœci towarów */

SELECT id_towar, nazwa, [1] AS '1-cyfrowe', [2] AS '2-cyfrowe', sk¹d, dok¹d, liczba_km, stawka_za_km
FROM
	(SELECT t.id_towar, t.nazwa, t.iloœæ, t.cena, LEN(t.iloœæ) AS d³_iloœci, u.sk¹d, u.dok¹d, u.liczba_km, u.stawka_za_km
	 FROM Towar t JOIN Us³uga u
	 ON t.id_towar=u.id_towar
	 GROUP BY t.id_towar, t.nazwa, t.iloœæ, t.cena, u.sk¹d, u.dok¹d, u.liczba_km, u.stawka_za_km
	 ) tabela2
PIVOT
	 (
	 SUM(cena)
	 FOR d³_iloœci IN ([1], [2])
	 ) AS pv2
ORDER BY id_towar, nazwa, sk¹d, dok¹d, liczba_km, stawka_za_km


--#########################################################################################################################
--#########################################################################################################################

--USUWANIE TABEL

DROP TABLE Kierowca
GO
DROP TABLE Kurs
GO
DROP TABLE Zaplecze_pojazdów
GO
DROP TABLE Pojazd
GO
DROP TABLE Uprawnienia
GO
DROP TABLE Klient
GO
DROP TABLE Uwagi
GO
DROP TABLE Zamówienie
GO
DROP TABLE Towar
GO
DROP TABLE Us³uga
GO

--USUWANIE WIDOKÓW
DROP VIEW Lista_sta³ych_klientów
GO
DROP VIEW Kierowcy_z_wiêkszym_wyposa¿eniem_transportowym
GO
DROP VIEW zamówione_towary
GO

--USUWANIE FUNKCJI

DROP FUNCTION dbo.sprawdz_pensja
GO
DROP FUNCTION dbo.konwersja_napisow
GO
DROP FUNCTION dbo.staz_pracy_pracownika_w_firmie
GO
DROP FUNCTION dbo.wyluskacz_id
GO

--USUWANIE PROCEDUR

DROP PROC pow_cena_i_wyp_nazw
GO
DROP PROC wprowadz_nowy_kierowca_i_jego_kurs
GO
DROP PROC zwiêksz_pensja_i_iloœæ
GO
DROP PROC wypisz_lata_zatrud
GO

--USUWANIE WYZWALACZY
DROP TRIGGER zm_zam_tow
GO
DROP TRIGGER usun_1_kierowce
GO
DROP TRIGGER zak_klient_wpr
GO
DROP TRIGGER wpr_nkier
GO
DROP TRIGGER us_nkier
GO

--#########################################################################################################################







 




 
	 
	 
	 
	 


 

	
	

 	
	 
	 
	 



	 
	 


	  
	    
	  
	   
 
 



	
	
	
 










	




