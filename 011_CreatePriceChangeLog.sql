USE Store
GO

--drop table ProductPriceUpdates
--GO

-- create table to save price updates
CREATE TABLE ProductPriceUpdates (
	ProductID BIGINT NOT NULL,
	NewPrice MONEY NOT NULL,
	UpdateDate DATETIME 
)
GO

ALTER TABLE ProductPriceUpdates
	ADD CONSTRAINT FK_ProductPriceUpdates_ProductID
		FOREIGN KEY (ProductID) REFERENCES Products(ID)
		ON DELETE NO ACTION 
	    ON UPDATE CASCADE
GO

INSERT INTO [dbo].[ProductPriceUpdates]
           ([ProductID]
           ,[NewPrice]
           ,[UpdateDate])
SELECT ID, Price, NULL
FROM Products
GO

CREATE TRIGGER TRG_ProductPriceUpdate
ON Products 
FOR UPDATE
AS
IF UPDATE (Price)
INSERT INTO ProductPriceUpdates(ProductID, NewPrice, UpdateDate)
SELECT ID, Price, GETDATE()
FROM INSERTED					--virtual table INSERTED keeps the row value after update

UPDATE Products 
SET Price = 500
WHERE ID = 1

UPDATE Products 
SET Price = 600
WHERE ID = 1

SELECT * FROM ProductPriceUpdates


UPDATE Products SET Price = 555 WHERE ID = 2--снять блокировку со строки 1
SELECT * FROM Products


