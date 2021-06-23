-- dodać jeszcze indeksy zamiast unique
-------- DROP TABLES --------

DROP TABLE IF EXISTS Wyposazenia_Samochodow
DROP TABLE IF EXISTS Dodatkowe_wyposazenia
DROP TABLE IF EXISTS Sprzedaze
DROP TABLE IF EXISTS Klienci
DROP TABLE IF EXISTS Modele_Dealerow
DROP TABLE IF EXISTS Silniki_Modeli
DROP TABLE IF EXISTS Samochody
DROP TABLE IF EXISTS Dealerzy
DROP TABLE IF EXISTS Typy_Silnika
DROP TABLE IF EXISTS Modele
DROP TABLE IF EXISTS Marki

GO

-------- CREATE TABLES AND RELATIONSHIPS --------

CREATE TABLE Marki
(
    nazwa            VARCHAR(30) CONSTRAINT pk_marki_nazwa PRIMARY KEY,
    rok_zalozenia    INT
);

CREATE TABLE Modele
(
    identyfikator       INT IDENTITY(1, 1) CONSTRAINT pk_modele_id PRIMARY KEY,
    nazwa               VARCHAR(30),
    rok_wprowadzenia    INT,
    nazwa_marki         VARCHAR(30) NOT NULL CONSTRAINT fk_nazwa_marki FOREIGN KEY REFERENCES Marki(nazwa),
    id_poprzednika      INT CONSTRAINT fk_id_poprz FOREIGN KEY REFERENCES Modele(identyfikator),
    typ                 VARCHAR(30) NOT NULL CONSTRAINT ck_modele_typ CHECK (typ IN ('osobowy', 'ciężarowy')),
    liczba_pasazerow    INT,
    poj_bagaznika       INT,
    ladownosc           INT, 
    -- CONSTRAINT uniq_id_poprz UNIQUE (id_poprzednika, nazwa_marki) zamiast tego index
);

CREATE UNIQUE INDEX uidx_modele_poprz
ON Modele(id_poprzednika)
WHERE id_poprzednika IS NOT NULL;

CREATE TABLE Typy_Silnika
(
    identyfikator      INT IDENTITY(10, 10) CONSTRAINT pk_typy_silnika_id PRIMARY KEY, -- od 10 co 10, poniewaz 
    opis_parametrow    VARCHAR(50),                                                    -- od 1 co 1 jest PK id Modelu 
    rodzaj_paliwa      VARCHAR(20)    
);

CREATE TABLE Silniki_Modeli
(
    id_modelu     INT CONSTRAINT fk_id_modelu FOREIGN KEY REFERENCES Modele(identyfikator),
    id_silnika    INT NOT NULL CONSTRAINT fk_id_silnika FOREIGN KEY REFERENCES Typy_Silnika(identyfikator),
    CONSTRAINT    pk_silniki_modeli PRIMARY KEY (id_modelu, id_silnika)
);

CREATE TABLE Dealerzy
(
    nazwa    VARCHAR(20) CONSTRAINT pk_dealerzy_nazwa PRIMARY KEY,
    adres    VARCHAR(40)
);

CREATE TABLE Samochody
(
    VIN                 CHAR(17) CONSTRAINT pk_samochody_VIN PRIMARY KEY,
    przebieg            INT,
    skrzynia_biegow     VARCHAR(20),
    kraj_pochodzenia    VARCHAR(20),
    rok_produkcji       INT,
    id_modelu           INT NOT NULL CONSTRAINT fk_samoch_id_modelu  FOREIGN KEY REFERENCES Modele(identyfikator),
    id_silnika          INT NOT NULL CONSTRAINT fk_samoch_id_silnika FOREIGN KEY REFERENCES Typy_Silnika(identyfikator),
    nazwa_dealera       VARCHAR(20)  CONSTRAINT fk_samoch_nazwa_dealera FOREIGN KEY REFERENCES Dealerzy(nazwa)
);

CREATE TABLE Dodatkowe_wyposazenia
(
    nazwa    VARCHAR(20) CONSTRAINT pk_dod_wyposaz_nazwa PRIMARY KEY
);

CREATE TABLE Wyposazenia_Samochodow
(
    nazwa_wyposazenia    VARCHAR(20) CONSTRAINT fk_wyposaz_nazwa FOREIGN KEY REFERENCES Dodatkowe_wyposazenia(nazwa),
    VIN_samochodu        CHAR(17)    CONSTRAINT fk_wyposaz_vin FOREIGN KEY REFERENCES Samochody(VIN),
    CONSTRAINT pk_wyposaz PRIMARY KEY   (nazwa_wyposazenia, VIN_samochodu)
);

CREATE TABLE Modele_Dealerow
(
    id_modelu        INT NOT NULL CONSTRAINT fk_modele_dealerow_id FOREIGN KEY REFERENCES Modele(identyfikator),
    nazwa_dealera    VARCHAR(20)  CONSTRAINT fk_modele_dealerow_nazwa FOREIGN KEY REFERENCES Dealerzy(nazwa)
    CONSTRAINT pk_modele_dealerow PRIMARY KEY      (id_modelu, nazwa_dealera)
);

CREATE TABLE Klienci
(
    id             CHAR(11) CONSTRAINT pk_klienci_id PRIMARY KEY, -- dla ułatwienia id to PESEL
    imie           VARCHAR(20),
    nazwisko       VARCHAR(30),
    nr_telefonu    CHAR(9)   
);

CREATE TABLE Sprzedaze
(
    data_sprzedazy    DATE,
    nazwa_dealera     VARCHAR(20) CONSTRAINT fk_sprzedaze_dealer FOREIGN KEY REFERENCES Dealerzy(nazwa),
    id_klienta        CHAR(11)    CONSTRAINT fk_sprzedaze_klient FOREIGN KEY REFERENCES Klienci(id),
    VIN_samochodu     CHAR(17)    CONSTRAINT fk_sprzedaze_vin    FOREIGN KEY REFERENCES Samochody(VIN),
    cena              MONEY,
    CONSTRAINT pk_sprzedaze PRIMARY KEY (data_sprzedazy, nazwa_dealera, id_klienta)
);

GO 

-------- INSERT VALUES --------

INSERT INTO Marki VALUES
('BMW', 1916),
('Audi', 1909),
('Toyota', 1937);

INSERT INTO Modele VALUES
('Seria 1', 2004, 'BMW', NULL, 'osobowy', 5, 400, NULL),
('Seria 2', 2006, 'BMW', 1, 'osobowy', 4, 450, NULL),
('A8', 2016, 'Audi', NULL, 'osobowy', 5, 525, NULL),
('Proace', 2016, 'Toyota', NULL, 'ciężarowy', NULL, NULL, 1400),
('Proace II Family', 2018, 'Toyota', 4, 'ciężarowy', NULL, NULL, 1900);

INSERT INTO Typy_Silnika VALUES
('R4 1,6 l (1597 cm³), DOHC', 'benzynowy'),
('R6 3,0 l (2979 cm³), DOHC, biturbo', 'benzynowy'),
('V8 4,2 l (4172 cm³), DOHC', 'benzynowy'),
('R4 2,0 l (1995 cm³), DOHC, turbo', 'diesel'),
('V8 3,3 l (3328 cm³), DOHC, 2xturbo', 'diesel');

INSERT INTO Silniki_Modeli VALUES
(1, 10),
(1, 20),
(1, 40),
(2, 20),
(2, 40),
(3, 50),
(4, 10),
(5, 20),
(5, 40);

INSERT INTO Dealerzy(nazwa, adres) VALUES
('Dynamic Motors', 'Toruń, Kwiatowa 34'),
('Auto Fus Group', 'Poznań, Mostowa 10'),
('Konarzewski Auto', 'Warszawa, Marszałkowska 34/10')

INSERT INTO Samochody VALUES
('WAUZZZ4G7DN064163', 68500, '6-biegowa manualna', 'Niemcy', 2003, 1, 20, 'Dynamic Motors'),
('SB164ZEB10E046860', 185650, '5-biegowa manualna', 'Niemcy', 2006, 2, 20, 'Auto Fus Group'),
('WBACG11000KD26155', 250000, '6-biegowa manualna', 'Francja', 2005, 2, 40, 'Konarzewski Auto'),
('W0L0MAP08G6012898', 99250, 'automatyczna', 'Niemcy', 2012, 3, 50, 'Dynamic Motors'),
('WBA3K31060F667253', 142550, '6-biegowa manualna', 'Japonia', 2013, 4, 10, 'Konarzewski Auto'),
('YV1BZ8046A1087344', 0, '6-biegowa manualna', 'Japonia', 2015, 5, 40, 'Auto Fus Group'),
('ZFA19900000035517', 55250, 'pół-automatyczna', 'Stany Zjednoczone', 2016, 5, 20, 'Dynamic Motors');

INSERT INTO Dodatkowe_wyposazenia VALUES
('Połączenie Bluetooth'),
('Asystent parkowania'),
('Podgrzewane fotele'),
('GPS');

INSERT INTO Wyposazenia_Samochodow VALUES
('GPS', 'WAUZZZ4G7DN064163'),
('Połączenie Bluetooth', 'WAUZZZ4G7DN064163'),
('Podgrzewane fotele', 'SB164ZEB10E046860'),
('GPS', 'W0L0MAP08G6012898'),
('Asystent parkowania', 'W0L0MAP08G6012898'),
('Połączenie Bluetooth', 'W0L0MAP08G6012898'),
('Połączenie Bluetooth', 'YV1BZ8046A1087344'),
('GPS', 'ZFA19900000035517');

INSERT INTO Modele_Dealerow VALUES
(1, 'Dynamic Motors'),
(1, 'Konarzewski Auto'),
(2, 'Konarzewski Auto'),
(2, 'Auto Fus Group'),
(3, 'Dynamic Motors'),
(3, 'Auto Fus Group'),
(4, 'Konarzewski Auto'),
(5, 'Auto Fus Group'),
(5, 'Dynamic Motors');

INSERT INTO Klienci VALUES
('55030101193', 'Jan', 'Kowalski', '666777888'),
('01024601121', 'Jędrzej', 'Rybczyński', '605602341'),
('95231245248', 'Anna', 'Nowak', '691272422');

INSERT INTO Sprzedaze VALUES
('2020-09-17', 'Dynamic Motors', '01024601121', 'WAUZZZ4G7DN064163', 25000),
('2021-03-07', 'Dynamic Motors', '95231245248', 'ZFA19900000035517', 115000),
('2021-05-23', 'Konarzewski Auto', '55030101193', 'WBACG11000KD26155', 59000),
('2021-05-28', 'Auto Fus Group', '55030101193', 'YV1BZ8046A1087344', 350000);

GO

-------- SELECT --------

SELECT * FROM Marki;
SELECT * FROM Modele;
SELECT * FROM Typy_Silnika;
SELECT * FROM Silniki_Modeli;
SELECT * FROM Dealerzy;
SELECT * FROM Samochody;
SELECT * FROM Dodatkowe_wyposazenia;
SELECT * FROM Wyposazenia_Samochodow;
SELECT * FROM Modele_Dealerow;
SELECT * FROM Klienci;
SELECT * FROM Sprzedaze;

GO
------------------------