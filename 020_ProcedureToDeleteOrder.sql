

DROP PROCEDURE RemoveOrder
GO 

CREATE PROCEDURE RemoveOrder
	@Number BIGINT,
	@ProductID BIGINT,
	@DateInterval TINYINT = 1
AS
BEGIN
    IF(@Number IS NULL) OR NOT EXISTS
	(
		SELECT *
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN
		RETURN 1
	END

	 IF(@ProductID IS NULL) OR NOT EXISTS
	(
		SELECT *
		FROM Products
		WHERE ID = @ProductID
	)
	BEGIN
		RETURN 3
	END

	DECLARE @RemovedConsigmentDate DATETIME

	SELECT @RemovedConsigmentDate = ConsignmentDate
	FROM Consignments
	WHERE Number = @Number

	IF(@RemovedConsigmentDate > DATEADD(DAY, @DateInterval, GETDATE()))
	BEGIN
		RETURN 2
	END

	DELETE FROM Orders
	WHERE ConsignmentNumber = @Number AND ProductID = @ProductID
	
	RETURN 0

END
GO
