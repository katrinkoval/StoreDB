-- =============================================
-- Author:		<Koval Kate>
-- Create date: <18.09.2023>
-- Description:	<Procedure to add new order>
-- =============================================
DROP PROCEDURE AddOrder
GO

CREATE PROCEDURE AddOrder
	@ConsigmentNumber BIGINT,
	@ProductID BIGINT,
	@Amount FLOAT = 1
AS
BEGIN
	--SET NOCOUNT ON;
	IF ((@ConsigmentNumber IS NOT NULL) AND EXISTS 
		(
			SELECT * 
			FROM Consignments 
			WHERE Number = @ConsigmentNumber
		)) 
		AND ((@ProductID IS NOT NULL) AND EXISTS 
		(
			SELECT * 
			FROM Products 
			WHERE ID = @ProductID
		)) 
		IF (NOT EXISTS 
		(
			SELECT * 
			FROM Orders 
			WHERE ProductID = @ProductID
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
SELECT * FROM iNDIVIDUALS

EXECUTE AddOrder 1300, 1, 2

EXECUTE AddOrder 1242, 1, 2

EXECUTE AddOrder 1242, 2, 2