
SELECT *
FROM ProductPriceUpdates
WHERE UpdateDate IN( '2023-09-10 20:37:19.433', NULL) 

INSERT INTO [dbo].[Consignments]
           ([Number]
           ,[ConsignmentDate]
           ,[SupplierID]
           ,[RecipientID])
     VALUES
           (1250, GETDATE(), 1,2)
GO



INSERT INTO [dbo].[Orders]
           ([ConsignmentNumber]
           ,[ProductID]
           ,[Amount])
     VALUES
           (1250, 1, 3)
GO

DECLARE @Number BIGINT = 1250;
DECLARE @OrderDate DATETIME;

SELECT @OrderDate = ConsignmentDate
FROM Consignments
WHERE Number = @Number

PRINT @OrderDate

SELECT PPU.NewPrice, PPU.ProductID, PPU.UpdateDate
INTO #ActualPriceList
			FROM ProductPriceUpdates PPU
			WHERE PPU.UpdateDate =  
			(
				SELECT MAX(PPU1.UpdateDate)
				FROM ProductPriceUpdates PPU1
				WHERE PPU.ProductID = PPU1.ProductID AND PPU1.UpdateDate <= @OrderDate
			)

SELECT * FROM #ActualPriceList
SELECT * FROM ProductPriceUpdates
GO 

DECLARE @Number BIGINT = 1250;
DECLARE @OrderDate DATETIME;

SELECT @OrderDate = ConsignmentDate
FROM Consignments
WHERE Number = @Number

SELECT C.Number, C.ConsignmentDate, I1.Name + ' ' + I1.Surname AS Supplier, I2.Name + ' ' + I2.Surname AS Recipient
		, P.Name, U.UnitType, O.Amount,
		(
			SELECT NewPrice
			FROM #ActualPriceList
			WHERE P.ID = ProductID
		) AS Price,
		(
			SELECT NewPrice
			FROM #ActualPriceList
			WHERE P.ID = ProductID
		) * O.Amount AS TotalPrice
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
		LEFT JOIN Units U ON P.UnitID = U.ID
		LEFT JOIN Individuals I1 ON C.SupplierID = I1.IPN
		LEFT JOIN Individuals I2 ON C.RecipientID = I2.IPN
WHERE C.Number = @Number

GO

DECLARE @Number BIGINT = 1250;
DECLARE @OrderDate DATETIME;

SELECT @OrderDate = ConsignmentDate
FROM Consignments
WHERE Number = @Number

PRINT @OrderDate

SELECT PPU.NewPrice, PPU.ProductID, PPU.UpdateDate
INTO ##ActualPriceList
			FROM ProductPriceUpdates PPU
			WHERE PPU.UpdateDate =  
			(
				SELECT MAX(PPU1.UpdateDate)
				FROM ProductPriceUpdates PPU1
				WHERE PPU.ProductID = PPU1.ProductID AND PPU1.UpdateDate <= @OrderDate
			)

SELECT * FROM ##ActualPriceList
SELECT * FROM ProductPriceUpdates
GO 
