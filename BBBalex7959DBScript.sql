USE Master
GO
IF DB_ID('BBBalex7959') IS NOT NULL
	BEGIN
		ALTER DATABASE BBBalex7959 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE BBBalex7959
	END
GO
CREATE DATABASE BBBalex7959
GO
USE BBBalex7959
GO


DROP TABLE IF EXISTS Vaskeri
CREATE TABLE Vaskeri (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Navn NVARCHAR(255) NOT NULL,
OpenTime TIME NOT NULL,
CloseTime TIME NOT NULL,
)
GO

DROP TABLE IF EXISTS Maskine
CREATE TABLE Maskine (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Navn NVARCHAR(255) NOT NULL,
Pris DECIMAL (10,2) NOT NULL,
VasketidIMinutter INT NOT NULL,
VaskeriId INT FOREIGN KEY REFERENCES Vaskeri(Id) NOT NULL,
)
GO

DROP TABLE IF EXISTS Bruger
CREATE TABLE Bruger (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Navn NVARCHAR(255) NOT NULL,
[E-mail] NVARCHAR(255) UNIQUE NOT NULL,
[Password] NVARCHAR(255) NOT NULL CONSTRAINT CK_Brugere_Password CHECK(LEN([PASSWORD]) >4),
Konto DECIMAL(10,2) NOT NULL,
VaskeriId INT FOREIGN KEY REFERENCES Vaskeri(Id) NOT NULL,
DatoForOprettelse DATETIME NOT NULL	,
)
GO

DROP TABLE IF EXISTS Bookning
CREATE TABLE Bookning (
Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
TidspunktForVask DATETIME NOT NULL CONSTRAINT CK_Booking_TidspunktForVask CHECK (),
BrugerId INT FOREIGN KEY REFERENCES Bruger(Id) NOT NULL,
MaskineId INT FOREIGN KEY REFERENCES Maskine(Id) NOT NULL,
)
GO

INSERT INTO Vaskeri (Navn, OpenTime, CloseTime) VALUES ('Whitewash Inc.','08:00','20:00')
INSERT INTO Vaskeri (Navn, OpenTime, CloseTime) VALUES ('Double Bubble','02:00','22:00')
INSERT INTO Vaskeri (Navn, OpenTime, CloseTime) VALUES ('Wash & Coffee','12:00','20:00')
GO

INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('Mielle 911 Turbo', 5.00, 60, 2)
INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('IClean', 10000.00, 30, 1)
INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('Electrolax FX', 15.00, 45, 2)
INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('NASA Spacewasher 8000', 500.00, 5, 1)
INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('The Lost Sock', 3.50, 90, 3)
INSERT INTO Maskine (Navn, Pris, VasketidIMinutter, VaskeriId) VALUES ('Yo Mama', 5.00, 120, 3)
GO

INSERT INTO Bruger(Navn, [E-mail], [Password], Konto, VaskeriId, DatoForOprettelse) VALUES ('John', 'john_doe66@gmail.com', 'password', 100.00, 2, '2021-02-15')
INSERT INTO Bruger(Navn, [E-mail], [Password], Konto, VaskeriId, DatoForOprettelse) VALUES ('Neil Armstrong', 'firstman@nasa.gov', 'eagleLander69', 1000.00, 1, '2021-02-10')
INSERT INTO Bruger(Navn, [E-mail], [Password], Konto, VaskeriId, DatoForOprettelse) VALUES ('Batman', 'noreply@thecave.com', 'Rob1n', 500.00, 3, '2020-03-10')
INSERT INTO Bruger(Navn, [E-mail], [Password], Konto, VaskeriId, DatoForOprettelse) VALUES ('Goldman Sachs', 'moneylaundering@gs.com', 'NotRecognized', 100000.00, 1, '2021-01-01')
INSERT INTO Bruger(Navn, [E-mail], [Password], Konto, VaskeriId, DatoForOprettelse) VALUES ('50 Cent', '50cent@gmail.com', 'ItsMyBirthday', 0.50, 3, '2020-07-06')
GO	

INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 12:00:00',1,1)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 16:00:00',1,3)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 08:00:00',2,4)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 15:00:00',3,5)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 20:00:00',4,2)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 19:00:00',4,2)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 10:00:00',4,2)
INSERT INTO Bookning(TidspunktForVask, BrugerId, MaskineId) VALUES ('2021-02-26 16:00:00',5,6)
GO

-- Opgave 8 --

BEGIN TRANSACTION Goldman
	INSERT INTO Bookning (TidspunktForVask, BrugerId, MaskineId) VALUES ('2022-09-15 12:00:00', 4, 2)
COMMIT
GO

-- Opgave 9 --

DROP VIEW IF EXISTS BookingView
GO
CREATE VIEW BookingView AS
	SELECT Bookning.TidspunktForVask AS 'Tidspunkt For Vask', Bruger.Navn AS 'Bruger Navn', Maskine.Navn AS 'Maskine', Maskine.Pris AS 'Pris'
	FROM Bookning
	RIGHT JOIN Bruger ON Bookning.BrugerId = Bruger.Id
	RIGHT JOIN Maskine ON Bookning.MaskineId = Maskine.Id
GO


-- Opgave 10 --

SELECT * FROM Bruger WHERE [E-mail] LIKE '%@gmail.com%'
GO

SELECT * FROM Maskine
FULL JOIN Vaskeri ON Maskine.VaskeriId = Vaskeri.Id
GO

SELECT Maskine.Navn AS 'Maskine', COUNT(Bookning.MaskineId) FROM Bookning
JOIN Maskine ON Bookning.MaskineId = Maskine.Id
GROUP BY Maskine.Navn
GO

DELETE FROM Bookning Where TidspunktForVask BETWEEN CAST('12:00:00' AS DATETIME) AND CAST('13:00:00' AS DATETIME)
GO

UPDATE Bruger SET Password = 'SelinaKyle' WHERE Navn LIKE '%BATMAN%'
GO