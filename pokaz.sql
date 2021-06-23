-- add_car
-- blad w wyniku nieprawidlowego id modelu
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 999, 20, 'Dynamic Motors';

-- blad w wyniku nieprawidlowego id silnika
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 999, 'Dynamic Motors';

-- blad w wyniku nieprawidlowej nazwy dealera
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 20, 'Invalid name';

-- blad w wyniku nieprawidlowego roku produkcji
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2005, 1, 20, 'Dynamic Motors';

-- blad w wyniku nieprawidlowej nazwy wyposazenia
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 20, 'Dynamic Motors', 'GPSaaa';

-- prawidlowe bez wyposazenia
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 20, 'Dynamic Motors';

-- prawidlowe z wyposazeniem
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 20, 'Dynamic Motors', 'GPS';

SELECT * FROM Samochody;
SELECT * FROM Wyposazenia_Samochodow;
DELETE FROM Wyposazenia_Samochodow WHERE VIN_samochodu = 'TEST0000000000000';
DELETE FROM Samochody WHERE VIN = 'TEST0000000000000';
GO


-- sell_car
-- blad w wyniku nieprawidlowej nazwy dealera
EXEC sell_car 'Invalid name', '01024601121', 'WAUZZZ4G7DN064163', 99000;

-- blad w wyniku nieprawidlowego id klienta
EXEC sell_car 'Dynamic Motors', '00000000000', 'WAUZZZ4G7DN064163', 99000;

-- blad w wyniku nieprawidlowego vinu
EXEC sell_car 'Dynamic Motors', '01024601121', '00000000000000000', 99000;

-- prawidlowe bez podawania daty
EXEC sell_car 'Dynamic Motors', '01024601121', 'WAUZZZ4G7DN064163', 99000;

-- prawidlowe z podaniem daty
EXEC sell_car 'Dynamic Motors', '01024601121', 'WAUZZZ4G7DN064163', 99000, '11-11-2011';

SELECT * FROM Sprzedaze
DELETE FROM Sprzedaze WHERE data_sprzedazy = '2021-06-21';
DELETE FROM Sprzedaze WHERE data_sprzedazy = '11-11-2011';
GO


-- trigger_silnik
SELECT * FROM Silniki_Modeli;
-- spróbujmy dodaæ samochód o id 1 i modelu silnika 50 (nie ma takiego polaczenia w tabeli Silniki_Modeli)
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 50, 'Dynamic Motors'; 
-- a teraz o id 1 i modelu silnika 10 (jest takie polaczenie w tabeli Silniki_Modeli)
EXEC add_car 'TEST0000000000000', 30500, '6-biegowa manualna', 'Francja', 2003, 1, 10, 'Dynamic Motors';
SELECT * FROM Samochody;
DELETE FROM Samochody WHERE VIN = 'TEST0000000000000';
GO


-- trigger_modele
-- nie moga byc dwa typy na raz, spróbujmy dodaæ Audi A8 w wersji ciê¿arowejINSERT INTO Modele VALUES('A8', 2016, 'Audi', NULL, 'ciê¿arowy', 5, 525, NULL)-- i nie moze byc zaden inny typ niz ciê¿arowy/osobowy (to zapewnia CHECK)INSERT INTO Modele VALUES('A6', 2016, 'Audi', NULL, 'motor', 2, 400, NULL)-- prawid³oweINSERT INTO Modele VALUES('Seria 3', 2012, 'BMW', 2, 'osobowy', 4, 500, NULL)SELECT * FROM ModeleGO


-- raporty
SELECT * FROM zarobki_dealerow
ORDER BY srednie_zarobki DESC;

SELECT * FROM ilosc_marek
ORDER BY ilosc DESC;

SELECT * FROM osobowe_ciezarowe
ORDER BY ilosc DESC;
GO


