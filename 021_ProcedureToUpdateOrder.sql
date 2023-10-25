
DROP PROCEDURE UpdateOrder
GO 

CREATE PROCEDURE UpdateOrder
	@Number BIGINT,
	@ProductID BIGINT,
	@ProductIDUpdated BIGINT = NULL,
	@Amount FLOAT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	IF (@Number IS NULL) 
	BEGIN
		RETURN 1
	END
	
	IF(@ProductID IS NULL)
	BEGIN
		RETURN 2
	END

	IF (@ProductIDUpdated IS NOT NULL) AND NOT EXISTS 
	(
		SELECT ID 
		FROM Products
		WHERE ID = @ProductIDUpdated
	) 
	BEGIN
		RETURN 3
	END

	IF (@Amount IS NULL) 
	BEGIN
		SET @Amount = 1
	END

	UPDATE Orders	
	SET ProductID = ISNULL(@ProductIDUpdated, ProductID),
		Amount = ISNULL(@Amount, Amount)
	WHERE ConsignmentNumber= @Number AND ProductID = @ProductID

END
GO

