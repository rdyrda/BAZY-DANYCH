
-- AUTOR: RAFAL DYRDA

-- WERSJA NA PostgreSQL

-- STWORZENIE MOJEJ BAZY DANYCH
/* Sprawdzanie czy istnieje juz baza danych "PRZEDSIEBIORSTWO_TRANSPORTOWO_USLUGOWE" */


DROP DATABASE IF EXISTS "PRZEDSIEBIORSTWO_TRANSPORTOWO_USLUGOWE";

/* Tworzenie i korzystanie z bazy danych "PRZEDSIEBIORSTWO_TRANSPORTOWO_USLUGOWE" */

CREATE DATABASE "PRZEDSIEBIORSTWO_TRANSPORTOWO_USLUGOWE"
WITH OWNER = rdyrda
ENCODING = 'UTF8';
       
       
--#########################################################################################################################

-- PROJEKT 2: SKRYPT (create + insert i selecty tabel):

-- Polecenia CREATE:
--1) Tabela: KIEROWCA

/* Sprawdzanie czy istnieje tabela "kierowca" */

DROP TABLE IF EXISTS kierowca CASCADE;

/* Tworzenie tabeli: KIEROWCA */

CREATE TABLE kierowca (
id_kierowca SERIAL PRIMARY KEY,
PESEL CHAR(11) NOT NULL UNIQUE,
imie VARCHAR(40) NOT NULL CHECK(LENGTH(imie)>2),
nazwisko VARCHAR(40) NOT NULL CHECK(LENGTH(nazwisko)>2),
miejscowosc VARCHAR(50) NOT NULL CHECK(LENGTH(miejscowosc)>2),
nr_domu INT NOT NULL,
nr_lokalu INT,
kod_pocztowy CHAR(6) NOT NULL,
telefon VARCHAR(9),
data_zatrudnienia DATE NOT NULL,
pensja DECIMAL(8,2) NOT NULL CHECK(pensja>=1000),
ulica VARCHAR(40) NOT NULL
);

--2) Tabela: KURS

/* Sprawdzanie czy istnieje tabela "kurs" */

DROP TABLE IF EXISTS kurs CASCADE;

/* Tworzenie tabeli: KURS */

CREATE TABLE kurs (
nr_kursu INT PRIMARY KEY,
dostepnosc VARCHAR(40) NOT NULL,
data_i_czas_rozpoczecia TIMESTAMP NOT NULL,
data_i_czas_zakonczenia TIMESTAMP 
);

--3) Tabela: ZAPLECZE POJAZDOW 

/* Sprawdzanie czy istnieje tabela "zaplecze_pojazdow" */

DROP TABLE IF EXISTS zaplecze_pojazdow CASCADE;

/* Tworzenie tabeli: ZAPLECZE POJAZDOW */

CREATE TABLE zaplecze_pojazdow (
dostepne_stanowisko SERIAL PRIMARY KEY,
stan VARCHAR(4) NOT NULL
);

--4) Tabela: POJAZD 

/* Sprawdzanie czy istnieje tabela "pojazd" */

DROP TABLE IF EXISTS pojazd CASCADE;

/* Tworzenie tabeli: POJAZD */

CREATE TABLE Pojazd (
nr_rejestracji VARCHAR(8) PRIMARY KEY,

id_kierowca INT, 
CONSTRAINT id_kierowca_fk FOREIGN KEY(id_kierowca) REFERENCES kierowca(id_kierowca)MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_kursu INT,
CONSTRAINT nr_kursu_fk FOREIGN KEY(nr_kursu) REFERENCES kurs(nr_kursu) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

dostepne_stanowisko INT,
CONSTRAINT dostepne_stanowisko_fk FOREIGN KEY(dostepne_stanowisko) REFERENCES zaplecze_pojazdow(dostepne_stanowisko) 
MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

marka VARCHAR(30) NOT NULL,
sprawnosc VARCHAR(10) NOT NULL,
liczba_miejsc INT NOT NULL,
kolor VARCHAR(30) NOT NULL,
nr_VIN VARCHAR(17) NOT NULL
);

--5) Tabela: UPRAWNIENIA 

/* Sprawdzanie czy istnieje tabela "uprawnienia" */

DROP TABLE IF EXISTS uprawnienia CASCADE;

/* Tworzenie tabeli: UPRAWNIENIA */

CREATE TABLE uprawnienia (
id_kierowca INT, 
CONSTRAINT id_kierowca_fk FOREIGN KEY(id_kierowca) REFERENCES kierowca(id_kierowca) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_rejestracji VARCHAR(8),
CONSTRAINT nr_rejestracji_fk FOREIGN KEY(nr_rejestracji) REFERENCES pojazd(nr_rejestracji) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_kursu INT,
CONSTRAINT nr_kursu_fk FOREIGN KEY(nr_kursu) REFERENCES kurs(nr_kursu) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

dostepne_stanowisko INT,
CONSTRAINT dostepne_stanowisko_fk FOREIGN KEY(dostepne_stanowisko) REFERENCES zaplecze_pojazdow(dostepne_stanowisko) 
MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

obecnosc VARCHAR(3) NOT NULL
);

--6) Tabela: KLIENT 

/* Sprawdzanie czy istnieje tabela "klient" */

DROP TABLE IF EXISTS klient CASCADE;

/* Tworzenie tabeli: KLIENT */

CREATE TABLE klient (
id_klient SERIAL PRIMARY KEY,
imie VARCHAR(40) NOT NULL CHECK(LENGTH(imie)>2),
nazwisko VARCHAR(40) NOT NULL CHECK(LENGTH(nazwisko)>2),
telefon VARCHAR(9),
miejscowosc VARCHAR(50) NOT NULL CHECK(LENGTH(miejscowosc)>2),
nr_domu INT NOT NULL,
nr_lokalu INT,
kod_pocztowy CHAR(6) NOT NULL,
ulica VARCHAR(40)
);

--7) Tabela: UWAGI 

/* Sprawdzanie czy istnieje tabela "uwagi" */

DROP TABLE IF EXISTS uwagi CASCADE;

/* Tworzenie tabeli: UWAGI */

CREATE TABLE uwagi (
dostepne_stanowisko INT,
CONSTRAINT dostepne_stanowisko_fk FOREIGN KEY(dostepne_stanowisko) REFERENCES zaplecze_pojazdow(dostepne_stanowisko) 
MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_kursu INT,
CONSTRAINT nr_kursu_fk FOREIGN KEY(nr_kursu) REFERENCES kurs(nr_kursu) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

id_kierowca INT, 
CONSTRAINT id_kierowca_fk FOREIGN KEY(id_kierowca) REFERENCES kierowca(id_kierowca) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_rejestracji VARCHAR(8),
CONSTRAINT nr_rejestracji_fk FOREIGN KEY(nr_rejestracji) REFERENCES pojazd(nr_rejestracji) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

id_klient INT, 
CONSTRAINT id_klient_fk FOREIGN KEY(id_klient) REFERENCES klient(id_klient) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

opis VARCHAR(255)
);

--8) Tabela: TOWAR 

/* Sprawdzanie czy istnieje tabela "towar" */

DROP TABLE IF EXISTS towar CASCADE;

/* Tworzenie tabeli: TOWAR */

CREATE TABLE towar (
id_towar SERIAL PRIMARY KEY,
nazwa VARCHAR(40) NOT NULL,
jednostka_miary VARCHAR(20) NOT NULL,
cena_za_1_jm_brutto DECIMAL(8,2) NOT NULL CHECK(cena_za_1_jm_brutto>0),
ilosc INT NOT NULL,
cena DECIMAL(8,2) NOT NULL CHECK(cena>0)
);

--9) Tabela: ZAMOWIENIE 

/* Sprawdzanie czy istnieje tabela "zamowienie" */

DROP TABLE IF EXISTS zamowienie CASCADE;

/* Tworzenie tabeli: ZAMOWIENIE */

CREATE TABLE zamowienie (
nr_zamowienia SERIAL PRIMARY KEY,

id_towar INT, 
CONSTRAINT id_towar_fk FOREIGN KEY(id_towar) REFERENCES towar(id_towar) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,
 
id_klient INT, 
CONSTRAINT id_klient_fk FOREIGN KEY(id_klient) REFERENCES klient(id_klient) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

data_zlozenia DATE 
);

--10) Tabela: USLUGA 

/* Sprawdzanie czy istnieje tabela "usluga" */

DROP TABLE IF EXISTS usluga CASCADE;

/* Tworzenie tabeli: USLUGA */

CREATE TABLE usluga (
id_usluga SERIAL PRIMARY KEY,

nr_kursu INT,
CONSTRAINT nr_kursu_fk FOREIGN KEY(nr_kursu) REFERENCES kurs(nr_kursu) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

id_towar INT, 
CONSTRAINT id_towar_fk FOREIGN KEY(id_towar) REFERENCES towar(id_towar) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

nr_zamowienia INT,
CONSTRAINT nr_zamowienia_fk FOREIGN KEY(nr_zamowienia) REFERENCES zamowienie(nr_zamowienia) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

id_klient INT, 
CONSTRAINT id_klient_fk FOREIGN KEY(id_klient) REFERENCES klient(id_klient) MATCH SIMPLE
ON UPDATE NO ACTION ON DELETE NO ACTION,

skad VARCHAR(30) NULL,
dokad VARCHAR(30) NULL,
liczba_km INT NULL,
stawka_za_km DECIMAL(8,2) NULL 
);

--#########################################################################################################################

--Polecenia INSERT:
-- 1) Wprowadzenie rekordow do tabeli: KIEROWCA 

INSERT INTO kierowca (PESEL, imie, nazwisko, miejscowosc, nr_domu, nr_lokalu, kod_pocztowy, telefon, data_zatrudnienia, pensja, ulica) VALUES
('87062300576','Damian','Krzychowski','Bieszkowice',18,6,'23-078','698242768','2009-04-23',3200,'Bialostocka'),
('64070321557','Emil','Pawlak','Walcz',8,NULL,'78-600','510567432','1993-05-12',4400,'Grabowa'),
('83112987903','Jozef','Bramowicz','Miroslawiec',12,3,'78-650',NULL,'2001-07-15',2900,'Szkolna'),
('76101621907','Krystian','Nowak','Gdansk',26,NULL,'25-050',NULL,'1998-02-23',5000,'Jesionowa'),
('90120187934','Dominik','Kowalski','Gdynia',105,36,'31-867','694768241','2011-08-31',1500,'Sienkiewicza'),
('70011093817','Adrian','Grzelak','Sopot',25,1,'81-459','768231059','1992-03-21',4000,'Czarnogorska');

-- 2) Wprowadzenie rekordow do tabeli: KURS 

INSERT INTO kurs (nr_kursu, dostepnosc, data_i_czas_rozpoczecia,  data_i_czas_zakonczenia) VALUES
(023072012,'jest dostepny','2012-07-10 08:00:00','2012-07-10 13:30:00'),
(031072012,'nie jest dostepny','2012-07-15 12:00:00',NULL),
(056072012,'nie jest dostepny','2012-07-16 14:45:00',NULL),
(072072012,'jest dostepny','2012-07-21 17:00:00','2012-07-22 06:00:00'),
(075072012,'jest dostepny','2012-07-23 05:00:00','2012-07-23 15:45:00'),
(084072012,'nie jest dostepny','2012-07-26 11:15:00',NULL);

-- 3) Wprowadzenie rekordow do tabeli: ZAPLECZE POJAZDÓW 

INSERT INTO Zaplecze_pojazdow (stan) VALUES
('TAK'),
('TAK'),
('NIE'),
('NIE'),
('NIE'),
('TAK');

-- 4) Wprowadzenie rekordow do tabeli: POJAZD 

INSERT INTO pojazd (nr_rejestracji, id_kierowca, nr_kursu, dostepne_stanowisko, marka, sprawnosc, liczba_miejsc, kolor, nr_VIN) VALUES
('GDA543L0',1,023072012,2,'MERCEDES 53487','jest',6,'srebrny','ASD548650IOTIY856'),
('GBY78U22',4,075072012,6,'SCANIA 78234','jest',6,'biały','SB5869230ERD09741'),
('CTR6720A',6,031072012,3,'RENAULT 94671','jest',5,'czarny','WNI739310683HRQ86'),
('ZKO54BN1',3,084072012,5,'BMW 76219','jest',5,'purpurowy','QSY933002175583UJ'),
('GWE63771',5,056072012,4,'VOLVO 11209','jest',7,'granatowy','PWE8821267345WQV0'),
('GSL94UY3',2,072072012,1,'MAGNUM 52183','jest',5,'zielony','SFD52791732004EZA');

-- 5) Wprowadzenie rekordow do tabeli: UPRAWNIENIA 

INSERT INTO uprawnienia (id_kierowca, nr_rejestracji, nr_kursu, dostepne_stanowisko, obecnosc) VALUES
(1,'GDA543L0',023072012,2,'TAK'),
(3,'ZKO54BN1',084072012,5,'NIE'),
(4,'GBY78U22',075072012,6,'TAK'),
(2,'GSL94UY3',072072012,1,'NIE'),
(5,'GWE63771',056072012,4,'TAK'),
(6,'CTR6720A',031072012,3,'NIE');

-- 6) Wprowadzenie rekordow do tabeli: KLIENT 

INSERT INTO klient (imie, nazwisko, telefon, miejscowosc, nr_domu, nr_lokalu, kod_pocztowy, ulica) VALUES
('Edward','Skrzetuski','697213793','Bialystok',19,2,'78-245','Gdanska'),
('Joanna','Nowozelska',NULL,'Warszawa',126,NULL,'00-300','Glowna'),
('Malgorzata','Bobryk','507123951','Gdansk',36,NULL,'23-916','Tropikalna'),
('Janusz','Kolabski',NULL,'Torun',7,4,'66-745','Reja'),
('Elwira','Pazdzioch','503267834','Bydgoszcz',98,16,'15-832','Zamostna'),
('Tadeusz','Skrzypkowski','500829174','Szczecin',78,NULL,'90-825','Wrzosowa');

-- 7) Wprowadzenie rekordow do tabeli: UWAGI 

INSERT INTO uwagi (dostepne_stanowisko, nr_kursu, id_kierowca, nr_rejestracji, id_klient, opis) VALUES
(2,023072012,1,'GDA543L0',3,'następnym razem przyjezdzac w godzinach popoludniowych'),
(1,072072012,2,'GSL94UY3',1,'zamowienia beda dostarczane tylko przez tego kierowce'),
(5,084072012,3,'ZKO54BN1',2,NULL),
(6,075072012,4,'GBY78U22',5,'dostawa byla spozniona'),
(4,056072012,5,'GWE63771',4,NULL),
(3,031072012,6,'CTR6720A',6,NULL);

-- 8) Wprowadzenie rekordow do tabeli: TOWAR 

INSERT INTO towar (nazwa, jednostka_miary, cena_za_1_jm_brutto, ilosc, cena) VALUES
('Pralka BEKO A8621','szt.',1299,1,1299),
('Telewizor SAMSUNG TE784','szt.',1500,1,1500),
('Karma dla psa CHAPPY','kg',6.30,30,189),
('Karta pamieci SD CARD 16GB','szt.',49,15,735),
('Drzwi PORTA antywlamaniowe AW287','szt.',300,6,1800);

-- 9) Wprowadzenie rekordow do tabeli: ZAMÓWIENIE 

INSERT INTO zamowienie (id_towar, id_klient, data_zlozenia) VALUES
(NULL,NULL,NULL),
(NULL,NULL,NULL),
(1,5,'2012-07-20'),
(3,1,'2012-07-15'),
(4,3,'2012-07-03'),
(NULL,NULL,NULL);

-- 10) Wprowadzenie rekordow do tabeli: USLUGA 

INSERT INTO usluga (nr_kursu, id_towar, nr_zamowienia, id_klient, skad, dokad, liczba_km, stawka_za_km) VALUES
(NULL,2,NULL,NULL,NULL,NULL,NULL,NULL),
(075072012,1,3,5,'Wejherowo','Bydgoszcz',300,2),
(023072012,4,5,3,'Wejherowo','Gdansk',45,3.20),
(072072012,3,4,1,'Wejherowo','Bialystok',400,5),
(NULL,5,NULL,NULL,NULL,NULL,NULL,NULL);

--#########################################################################################################################  

-- Polecenia SELECT:
--1

/* Wyswietla laczne kwoty towarow wedlug zamowienia */
SELECT t.id_towar, t.nazwa, SUM(t.cena) AS 'laczna_cena', z.data_zlozenia
FROM towar t LEFT JOIN zamowienie z
ON t.id_towar=z.id_towar
GROUP BY t.id_towar, t.nazwa, z.data_zlozenia;

--2
 
/* Wyswietla kierowcow oraz korzystane przez ich pojazdy */
ELECT k.imie, k.nazwisko, p.nr_rejestracji, p.nr_kursu, p.marka, p.kolor, p.nr_vin
FROM kierowca k FULL JOIN pojazd p
ON k.id_kierowca=p.id_kierowca;

--3

/* Wyswietla personalia kierowcow majacy "a" w imieniu oraz "N" w marce prowadzonych przez nich pojazdow, obecnosc uprawnien i 
zglaszanych uwag */
SELECT k.id_kierowca, k.imie, k.nazwisko, p.nr_rejestracji, p.marka, u.dostepne_stanowisko, u.obecnosc, uw.opis 
FROM kierowca k JOIN pojazd p
ON k.id_kierowca=p.id_kierowca
JOIN uprawnienia u 
ON k.id_kierowca=u.id_kierowca 
JOIN uwagi uw
ON k.id_kierowca=uw.id_kierowca
WHERE imie LIKE '%a%' AND marka LIKE '%N%'
ORDER BY k.id_kierowca;

--4

/* Wyswietla personalia klientow, ich zamowienia oraz dotyczace ich kursu i wypisuje pod wzgledem liczby nr domu mniejszej od 
   jej sredniej */
SELECT kl.id_klient, kl.imie, kl.nazwisko, kl.telefon, kl.nr_domu, z.nr_zamowienia, z.data_zlozenia, t.nazwa, t.cena, u.nr_kursu
FROM klient kl JOIN zamowienie z
ON kl.id_klient=z.id_klient
JOIN towar t
ON z.id_klient=t.id_towar
JOIN usluga u 
ON kl.id_klient=u.id_klient
WHERE nr_domu<(SELECT AVG(nr_domu) FROM klient)
ORDER BY nr_domu DESC;

--5

/* Wyswietla informacje na temat zamowionych towarow oraz ich laczne ceny netto i podatek VAT */
SELECT t.id_towar, t.nazwa, t.jednostka_miary, t.ilosc, 
(cena/1.23)  as cena_netto, ((cena/1.23)*0.23) as VAT, t.cena from towar t;    
       
--######################################################################################################################### 
--######################################################################################################################### 

-- PROJEKT 3: SKRYPT: REPREZENTANTY

--1) WIDOK 1
/* Sprawdzanie, czy istnieje widok "Lista_stalych_klientow" */

DROP VIEW IF EXISTS Lista_stalych_klientow;


/* Tworzenie widoku, ktory przechowuje dane na temat klientow, ktorzy mieszkaja najblizej firmy i sa stalymi klientami, 
a ich kierowcy wyjezdzaja z Wejherowa */

CREATE VIEW Lista_stalych_klientow
AS
SELECT kl.id_klient, kl.imie, kl.nazwisko, kl.miejscowosc, SUM(kl.nr_domu) AS licznik_nr_domow, kl.ulica, kl.kod_pocztowy, 
     u.opis, t.nazwa, t.jednostka_miary, t.ilosc, t.cena, us.skad FROM klient kl FULL JOIN uwagi u
	ON kl.id_klient=u.id_klient JOIN towar t
		ON u.id_klient=t.id_towar JOIN usluga us
			ON kl.id_klient=us.id_klient
	GROUP BY kl.id_klient, kl.imie, kl.nazwisko, kl.miejscowosc, kl.ulica, kl.kod_pocztowy, u.opis, t.nazwa,
		     t.jednostka_miary, t.ilosc, t.cena, us.skad
HAVING SUM(kl.nr_domu)<(SELECT AVG(nr_domu) FROM klient);


/* Przykladowe wywolanie widoku "Lista_stalych_klientow" z uzyciem instrukcji CASE */

SELECT CASE WHEN id_klient<4 THEN 'Tak. Wystepuje w wyswietlonym widoku' 
			ELSE 'Nie. Nie wystepuje w wyswietlonym widoku'
	   END AS "Czy wystepuja klienci ponizej id_klient 4 ?", * 
FROM Lista_stalych_klientow; */
    
/* Sprawdzanie, czy istnieje funkcja "sprawdz_pensja" */

DROP FUNCTION IF EXISTS sprawdz_pensja;

/* Tworzenie funkcji z parametrem, która po podaniu kwoty porównuje ją ze średnią pensją kierowców i po wywołaniu wypisuje 
odpowiedni komunikat */

CREATE FUNCTION sprawdz_pensja (DECIMAL);
RETURNS TEXT AS $$
DECLARE napis TEXT;
		liczba DECIMAL(8,2);
BEGIN
	 napis =  CASE
		 
					WHEN liczba=(SELECT AVG(pensja) FROM Kierowca) THEN 'Tyle wynosi srednia pensja kierowcow'
		 
					WHEN liczba<(SELECT AVG(pensja) FROM Kierowca) THEN 'Podana pensja jest mniejsza od sredniej pensji kierowcow'
		 
					ELSE 'Podana pensja jest wieksza od sredniej pensji kierowcow'
			  END
	
	 RETURN; 
END
$$
LANGUAGE 'plpgsql';

/* Przykładowe wywołanie funkcji "sprawdz_pensja" */

SELECT sprawdz_pensja(3200);
