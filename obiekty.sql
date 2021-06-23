CREATE OR ALTER PROCEDURE add_car
(
    @VIN                 CHAR(17),
    @przebieg            INT,
    @skrzynia_biegow     VARCHAR(20),
    @kraj_pochodzenia    VARCHAR(20),
    @rok_produkcji       INT,
    @id_modelu           INT,
    @id_silnika          INT,
    @nazwa_dealera       VARCHAR(20),
    @nazwa_wyposazenia   VARCHAR(20) = NULL
)
AS
    -- jesli podany rok produkcji jest pozniejszy od roku wprowadzenia jest to blad logiczny
    IF @rok_produkcji > (SELECT rok_wprowadzenia
                         FROM   Modele
                         WHERE  identyfikator = @id_modelu)
        BEGIN
            RAISERROR('Bledny rok produkcji', 16, 1);
            RETURN;
        END
    
    -- nalezy sprawdzic recznie nazwe wyposazenia gdyz w tabeli Samochody nie przechowujemy o niej informacji
    IF @nazwa_wyposazenia NOT IN  (SELECT nazwa
                                   FROM   Dodatkowe_wyposazenia)
        BEGIN
            RAISERROR('Bledna nazwa wyposazenia', 16, 1);
            RETURN;
        END

    BEGIN TRY
        INSERT INTO Samochody
        VALUES (@VIN, @przebieg, @skrzynia_biegow, @kraj_pochodzenia, @rok_produkcji, @id_modelu, @id_silnika, @nazwa_dealera)

        IF @nazwa_wyposazenia IS NOT NULL
            BEGIN 
                INSERT INTO Wyposazenia_Samochodow
                VALUES (@nazwa_wyposazenia, @VIN)
            END 
    END TRY

    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
GO

CREATE OR ALTER PROCEDURE sell_car
(
    @nazwa_dealera       VARCHAR(20),
    @id_klienta          CHAR(11),
    @VIN_samochodu       CHAR(17),
    @cena                MONEY,
    @data_sprzedazy      DATE = NULL
)
AS
    BEGIN TRY
        INSERT INTO Sprzedaze
        VALUES (ISNULL(@data_sprzedazy, GETDATE()), @nazwa_dealera, @id_klienta, @VIN_samochodu, @cena)        
    END TRY

    BEGIN CATCH
        SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
GO

CREATE OR ALTER TRIGGER trigger_silnik
ON Samochody
AFTER INSERT, UPDATE
AS
    IF NOT EXISTS (SELECT *
                   FROM Silniki_Modeli
                   INNER JOIN inserted
                           ON inserted.id_modelu = Silniki_Modeli.id_modelu
                   WHERE Silniki_Modeli.id_silnika = inserted.id_silnika)    BEGIN        ROLLBACK    ENDGOCREATE OR ALTER TRIGGER trigger_modeleON Modele
AFTER INSERT, UPDATE
AS
    IF EXISTS (SELECT *
               FROM Modele
               INNER JOIN inserted
                       ON Modele.nazwa = inserted.nazwa
                       AND Modele.nazwa_marki = inserted.nazwa_marki
                       AND Modele.identyfikator != inserted.identyfikator)
    BEGIN        ROLLBACK    END
GO

CREATE OR ALTER VIEW zarobki_dealerow
AS
(
    SELECT nazwa_dealera, AVG(cena) AS [srednie_zarobki]
    FROM Sprzedaze
    GROUP BY nazwa_dealera
);
GO

CREATE OR ALTER VIEW ilosc_marek
AS 
(
    SELECT nazwa_marki, COUNT(nazwa) AS [ilosc]
    FROM Modele
    GROUP BY nazwa_marki
);
GO

CREATE OR ALTER VIEW osobowe_ciezarowe
AS 
(
    SELECT typ, COUNT(typ) AS [ilosc]
    FROM Modele
    GROUP BY typ
);
GO