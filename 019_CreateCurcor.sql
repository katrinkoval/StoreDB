USE Store
GO

IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[GetTotalPrice]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].GetTotalPrice
END
GO

CREATE PROCEDURE GetTotalPrice
	@ConsigmentNumber BIGINT,
	@ConsignmentDate DATETIME,	--по номеру накладной
	@TotalPrice BIGINT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

-----------------------------------------------------------------------------------
--create temporary table to actual prices
	SELECT PPU.NewPrice, PPU.ProductID, PPU.UpdateDate
	INTO #ActualPriceList
	FROM ProductPriceUpdates PPU
	WHERE (PPU.UpdateDate IS NOT NULL AND PPU.UpdateDate =
	(
		SELECT MAX(PPU1.UpdateDate)
		FROM ProductPriceUpdates PPU1
		WHERE PPU.ProductID = PPU1.ProductID AND PPU1.UpdateDate <= @ConsignmentDate	
	) )
	OR (PPU.UpdateDate IS NULL AND NOT EXISTS
		(
			SELECT UpdateDate
			FROM ProductPriceUpdates PPU1
			WHERE PPU.ProductID = PPU1.ProductID AND PPU1.UpdateDate IS NOT NULL
		)
	)
--------------------------------------------------------------------------------------------
--cursor for orders 
	DECLARE @ProductID BIGINT
	DECLARE @Amount BIGINT
	DECLARE @TotalProductPrice BIGINT

	DECLARE order_cursor CURSOR FOR
	SELECT [ProductID], [Amount]
	FROM Orders
	WHERE ConsignmentNumber = @ConsigmentNumber

	OPEN order_cursor

	FETCH NEXT FROM order_cursor   
	INTO @ProductID, @Amount

	WHILE @@FETCH_STATUS = 0  
	BEGIN  

	SELECT @TotalProductPrice = NewPrice * @Amount
	FROM #ActualPriceList
	WHERE ProductID = @ProductID

	SET @TotalPrice = @TotalPrice + @TotalProductPrice

	FETCH NEXT FROM order_cursor   
	INTO @ProdUctID, @Amount
	END

	CLOSE order_cursor;
	DEALLOCATE order_cursor;
------------------------------------------------------------------------------------------------
	DROP TABLE #ActualPriceList
END
GO

SELECT Number, ConsignmentDate, SupplierID, RecipientID, 0.0 AS 'TotalPrice'
INTO #ConsigmentsTotalPrice
	FROM Consignments

DECLARE @Number BIGINT
DECLARE @ConsigmentDate DATETIME
--DECLARE @TotalPrice BIGINT

DECLARE consignment_cursor CURSOR FOR
SELECT [Number], [ConsignmentDate]
FROM #ConsigmentsTotalPrice

OPEN consignment_cursor

FETCH NEXT FROM consignment_cursor   
INTO @Number, @ConsigmentDate

WHILE @@FETCH_STATUS = 0  
BEGIN  

DECLARE @TotalPrice BIGINT
EXECUTE GetTotalPrice @Number, @ConsigmentDate, @TotalPrice OUTPUT 

UPDATE #ConsigmentsTotalPrice
SET TotalPrice = @TotalPrice

FETCH NEXT FROM consignment_cursor   
INTO @Number, @ConsigmentDate
END

CLOSE consignment_cursor;
DEALLOCATE consignment_cursor;



--test
GO
DECLARE @TotalPrice BIGINT = NULL
EXECUTE GetTotalPrice 1250, '2023-09-18 18:10:31.800', @TotalPrice OUTPUT 
PRINT @TotalPrice