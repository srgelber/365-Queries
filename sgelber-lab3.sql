-- BAKERY-1
UPDATE goods SET price = price - 2.00 WHERE GId = '20-BC-L-10' or GId = '46-11';

-- BAKERY-2
UPDATE goods SET price = price * 1.15 WHERE (Flavor = 'Apricot' or Flavor = 'Chocolate') and (Price < 5.95);

-- BAKERY-3
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    Receipt INTEGER(1) NOT NULL,
    Amount  DECIMAL(4,2) NOT NULL,
    PaymentSettled DATETIME NOT NULL,
    PaymentType VARCHAR(100) NOT NULL,
    Primary Key(Receipt, Amount, PaymentSettled, PaymentType),
    FOREIGN KEY (Receipt)
        REFERENCES  receipts (RNumber)
);

-- BAKERY-4
DROP TRIGGER no_meringues_no_almond;

CREATE TRIGGER no_meringues_no_almond BEFORE INSERT ON items
FOR EACH ROW
  BEGIN
    DECLARE FoodType VARCHAR(100);
    DECLARE FlavorType VARCHAR(100);
    DECLARE PurchaseDate DATE;
    SELECT Food INTO FoodType FROM goods WHERE GId = NEW.Item;
    SELECT Flavor INTO FlavorType FROM goods WHERE GId = NEW.Item;
    SELECT SaleDate INTO PurchaseDate FROM receipts WHERE RNumber = NEW.Receipt;
     IF ((FoodType = 'Meringue' or FlavorType = 'Almond') and (DAYOFWEEK(PurchaseDate) = 1 or DAYOFWEEK(PurchaseDate) = 7)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No Meringues or Almond Flavored Foods on Saturday or Sunday';
     END IF;
  END;

-- AIRLINES-1
DROP TRIGGER no_same_src_dest;

CREATE TRIGGER no_same_src_dest BEFORE INSERT ON flights
FOR EACH ROW
  BEGIN
     IF (NEW.SourceAirport = NEW.DestAirport) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No same SourceAiport and DestAirport';
     END IF;
  END;

-- AIRLINES-2
ALTER TABLE airlines ADD Partner VARCHAR(100) NULL;
ALTER TABLE airlines ADD CONSTRAINT Partner_Constraint UNIQUE(Partner);
ALTER TABLE airlines ADD FOREIGN KEY (Partner) REFERENCES airlines (Abbreviation);

UPDATE airlines SET Partner = 'JetBlue' WHERE Abbreviation = 'Southwest';
UPDATE airlines SET Partner = 'Southwest' WHERE Abbreviation = 'JetBlue';

DROP TRIGGER no_self_partnerships;

CREATE TRIGGER no_self_partnerships BEFORE INSERT ON airlines
FOR EACH ROW
  BEGIN
     IF (NEW.Partner = NEW.Abbreviation) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No Self Partnerships';
     END IF;
  END;

-- KATZENJAMMER-1
UPDATE Instruments SET Instrument = 'awesome bass balalaika' WHERE Instrument = 'bass balalaika';
UPDATE Instruments SET Instrument = 'acoustic guitar' WHERE Instrument = 'guitar';

-- KATZENJAMMER-2
DELETE FROM Vocals Where Type = 'lead' or Bandmate != 1;
