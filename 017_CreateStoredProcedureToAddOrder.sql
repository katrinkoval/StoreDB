-- =============================================
-- Author:		<Koval Kate>
-- Create date: <18.09.2023>
-- Description:	<Procedure to add new order>
-- =============================================

IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[AddOrder1]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].AddOrder
END
GO

CREATE PROCEDURE AddOrder1
	@ConsigmentNumber BIGINT,
	@ProductID BIGINT,
	@Amount FLOAT = 1.0
AS
BEGIN
	SET NOCOUNT ON;

	IF ((@ConsigmentNumber IS NOT NULL) AND EXISTS 
		(
			SELECT Number
			FROM Consignments 
			WHERE Number = @ConsigmentNumber
		)) 
		AND ((@ProductID IS NOT NULL) AND EXISTS 
		(
			SELECT ID
			FROM Products 
			WHERE ID = @ProductID
		)) 
		IF (NOT EXISTS 
		(
			SELECT ConsignmentNumber 
			FROM Orders 
			WHERE ConsignmentNumber = @ConsigmentNumber AND ProductID = @ProductID 
		))
		BEGIN
			INSERT INTO Orders
				  (ConsignmentNumber
				   , ProductID
				   , Amount)
			VALUES
			(@ConsigmentNumber, @ProductID, @Amount)
		END
		ELSE BEGIN
			UPDATE Orders
			SET Amount += @Amount
			WHERE ConsignmentNumber = @ConsigmentNumber AND ProductID = @ProductID
		END
	ELSE
	PRINT 'Incorrect values'
END
GO

SELECT * FROM Orders

EXECUTE AddOrder1 1300, 1, 2

EXECUTE AddOrder1 1242, 1, 2

EXECUTE AddOrder1 1242, 2, 2

-------------------------------------------------------------------------------------------------------------------------
IF EXISTS ( SELECT * 
            FROM   sysobjects 
            WHERE  id = object_id(N'[dbo].[AddOrder]') 
                   and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
    DROP PROCEDURE [dbo].AddOrder
END
GO

CREATE PROCEDURE AddOrder
	@ConsigmentNumber BIGINT,
	@ProductID BIGINT,
	@Amount FLOAT = 1.0,
	@ErrorCode BIGINT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF((@ConsigmentNumber IS NULL) OR NOT EXISTS 
		(
			SELECT Number
			FROM Consignments 
			WHERE Number = @ConsigmentNumber
		)) 
	BEGIN
	SET @ErrorCode = 1
	END

	IF ((@ProductID IS NULL) OR NOT EXISTS 
		(
			SELECT ID
			FROM Products 
			WHERE ID = @ProductID
		)) 
	BEGIN
	SET @ErrorCode = 2
	END

	IF (NOT EXISTS 
	(
		SELECT ConsignmentNumber 
		FROM Orders 
		WHERE ConsignmentNumber = @ConsigmentNumber AND ProductID = @ProductID 
	))
	BEGIN
		INSERT INTO Orders
				(ConsignmentNumber
				, ProductID
				, Amount)
		VALUES
		(@ConsigmentNumber, @ProductID, @Amount)
	END
	ELSE BEGIN
		UPDATE Orders
		SET Amount += @Amount
		WHERE ConsignmentNumber = @ConsigmentNumber AND ProductID = @ProductID
	END

	SET @ErrorCode = 0

END
GO

--TEST

DECLARE @ErrorCode BIGINT = NULL


EXECUTE AddOrder 1237, 1, 2, @ErrorCode OUTPUT

PRINT @ErrorCode
 
