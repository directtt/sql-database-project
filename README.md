# sql-database-project
SQL Database modeling and programming project for my Computer Science Database classes. [specific requirements in Polish]

## Opis zadania
W ramach projektu należy:
* zamodelować bazę odzwierciedlającą fragment rzeczywistości opisanej w jednym z poniższych tematów, w postaci diagramu ER, z wykorzystaniem wybranego narzędzia do projektowania,
* przekształcić diagramu do modelu relacyjnego (z uwzględnieniem kluczy obcych),
* stworzyć skrypt SQL zawierający polecenia CREATE TABLE oraz INSERT, który tworzy zaprojektowaną bazę i wypełnia ją przykładowymi wierszami
  * Skrypt SQL powinien uruchamiać się w całości i wielokrotnie.
  * W poleceniach tworzących tabele należy skupić się na typach danych i ograniczeniach integralnościowych.
  * Wszystkie ograniczenia integralnościowe PRIMARY KEY, FOREIGN KEY, UNIQUE i CHECK muszą być nazwane poprzez CONSTRAINT
  * Do każdej tabeli należy wstawić przynajmniej 3-4 wiersze tak dobrane, aby prezentowały istotę problemu i demonstrowały wykorzystanie ograniczeń integralnościowych.

W ramach projektu należy stworzyć zestaw skryptów SQL:
* **skrypt nr. 1** `obiekty.sql` zawierający definicje następujących obiektów bazodanowych:
  * procedury składowane (raportujące, wstawiające, usuwające modyfikujące dane),
  * funkcje użytkownika (skalarne i tablicowe),
  * procedury wyzwalane oraz widoki.
* wymienione wyżej obiekty programistyczne mają zostać użyte w sposób sensowny do implementacji poniższych wymagań: 
  * realizacja funkcjonalności bazy, której szczegóły zostały opisane osobno dla każdego projektu w "Opis tematów",
  * realizacja reguł biznesowych, których szczegóły zostały opisane osobno dla każdego projektu w "Opis tematów",
  * realizacja związku z obustronnym udziałem całkowitym ("musi"),
  * generowanie raportów.
 * **skrypt nr. 2** `pokaz.sql`:
  * skrypt zawierający polecenia testujące zaimplementowane funkcjonalności, pokazujące przypadki szczególne oraz sposób reakcji na błędy - a zatem przykładowe wywołania procedur, funkcji, wyzwalaczy i widoków.

## Opis tematu
### Autokomis
Marka posiada unikalną nazwę oraz rok założenia. Model posiada unikalny identyfikator, nazwę oraz rok wprowadzania na rynek. Marka musi mieć co najmniej jeden model (model musi należeć do jednej marki). Model musi być albo samochodem osobowym (wtedy przechowujemy dodatkowo informację o liczbie pasażerów oraz pojemności bagażnika) albo samochodem ciężarowym (wtedy przechowujemy dodatkowo informację o ładowności). Dany model (poprzednik) może mieć kolejną generację w postaci tylko jednego modelu (dany model (następnik) może być kolejną generacją tylko jednego modelu). Typ silnika posiada unikalny identyfikator, rodzaj paliwa oraz opis parametrów. Model musi mieć co najmniej jeden typ silnika (typ silnika może być związany z wieloma modelami). Samochód posiada unikalny VIN, przebieg, skrzynię biegów, kraj pochodzenia oraz rok produkcji. Model może mieć wiele samochodów (samochód musi być konkretnym modelem). Samochód musi mieć jeden typ silnika (typ silnika może być w wielu samochodach). Dodatkowe wyposażenie posiada unikalną nazwę. Samochód może posiadać wiele dodatkowych wyposażeń (dane dodatkowe wyposażenie może być w wielu samochodach). Dealer posiada unikalną nazwę oraz adres. Dealer może mieć w aktualnej ofercie wiele samochodów (samochód może być w aktualnej ofercie u jednego dealera). Dealer może mieć w swoim profilu wiele modeli (model może być w profilu wielu dealerów) [inaczej mówiąc, przez ten związek odzwierciedlamy informację, że dany dealer specjalizuje się w jakichś modelach samochodów]. Klient posiada unikalne id, imię, nazwisko oraz numer telefonu. Sprzedaż posiada dwa nieunikalne parametry, tj. datę i cenę. Dealer może uczestniczyć w wielu sprzedażach (dana sprzedaż musi być związana z jednym dealerem). Samochód może uczestniczyć w wielu sprzedażach (dana sprzedaż musi być związana z jednym samochodem). Klient musi uczestniczyć w co najmniej jednej sprzedaży (dana sprzedaż musi być związana z jednym klientem). Dodatkowo chcemy uwzględnić, że więcej niż jedna sprzedaż może dotyczyć tego samego samochodu od tego samego dilera temu samemu klientowi (takie sprzedaże różnią się wtedy przede wszystkim datą) [inaczej mówiąc, wskazujemy tutaj, że atrybut data encji Sprzedaże jest dyskryminujący].

Funkcjonalności:
* dodanie nowego samochodu do oferty dealera,
* sprzedaż samochodu.

Ograniczenia:
* wstawiany samochód musi mieć silnik występujący w danym modelu
* specjalizacja jest całkowita i rozłączna - a więc model musi być zapisany w bazie jako albo osobowy albo ciężarowy (nie dwa typy na raz i żaden inny typ)
