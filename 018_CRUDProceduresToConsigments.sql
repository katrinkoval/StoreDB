-- =============================================
-- Author:		<Koval Kate>
-- Create date: <18.03.2023>
-- Description:	<CRUD operations to Consignments>
-- =============================================

-- CREATE

CREATE PROCEDURE AddConsignment
	-- Add the parameters for the stored procedure here
	@Number BIGINT,
	@SupplierID BIGINT,
	@RecipientID BIGINT,
	@ConsigmentDate DATETIME = NULL,
	@SupplierName NVARCHAR(20) = NULL,
	@SupplierSurname NVARCHAR(20) = NULL,
	@RecipientName NVARCHAR(20) = NULL,
	@RecipientSurname NVARCHAR(20) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	IF (@Number IS NOT NULL) AND NOT EXISTS 
	(
		SELECT * 
		FROM Consignments
		WHERE Number = @Number
	)
	AND (@SupplierID IS NOT NULL) AND (@RecipientID IS NOT NULL) AND @SupplierID LIKE '_' AND @RecipientID LIKE '_'
	BEGIN
	--CHECK AND INSERT SUPPLIER 
		IF NOT EXISTS
		(
			SELECT * 
			FROM Individuals
			WHERE IPN = @SupplierID
		) 
		BEGIN 
			INSERT INTO [dbo].[Individuals]
			   ([IPN]
			   ,[Name]
			    ,[Surname])
			 VALUES
				 (@SupplierID, @SupplierName, @SupplierSurname)
		END
	--CHECK AND INSERT RECIPIENT 
		IF NOT EXISTS
		(
			SELECT * 
			FROM Individuals
			WHERE IPN = @RecipientID
		) 
		BEGIN 
			INSERT INTO [dbo].[Individuals]
			       ([IPN]
			       ,[Name]
			       ,[Surname])
			VALUES
				(@RecipientID, @RecipientName, @RecipientSurname)
		END
	-------------------------
	--VALIDATE @ConsigmentDate

	IF @ConsigmentDate IS NULL
	SET @ConsigmentDate = GETDATE();

	--------------------------
	INSERT INTO [dbo].[Consignments]
           ([Number]
           ,[ConsignmentDate]
           ,[SupplierID]
           ,[RecipientID])
     VALUES
           (@Number, @ConsigmentDate, @SupplierID,@RecipientID)
    END
END
GO

--Test

EXECUTE AddConsignment 1252, 1, 2
EXECUTE AddConsignment 1253, 1, 5, @RecipientName = 'Katerina', @RecipientSurname = 'Koval'

SELECT * FROM Consignments
SELECT * FROM Individuals


-----------------------------------------------------------------------------------------------------------
--READ
DROP PROCEDURE GetConsignment
GO

CREATE PROCEDURE GetConsignment
	@Number BIGINT = NULL,
	@SupplierSurname NVARCHAR(20) = NULL,
	@RecipientSurname NVARCHAR(20) = NULL
AS
BEGIN

	IF @SupplierSurname IS NOT NULL
	SET @SupplierSurname = '%' + @SupplierSurname + '%'

	IF @RecipientSurname IS NOT NULL
	SET @RecipientSurname = '%' + @RecipientSurname + '%'

	SELECT *
	FROM Consignments
	WHERE (@Number IS NULL) OR (Number = @Number) 
	AND (@SupplierSurname IS NULL) OR SupplierID = 
	(
		SELECT IPN
		FROM Individuals
		WHERE Surname LIKE @SupplierSurname
	)
	AND (@RecipientSurname IS NULL) OR RecipientID = 
	(
		SELECT IPN
		FROM Individuals
		WHERE Surname LIKE @RecipientSurname
	)
END
GO

--Test

EXECUTE GetConsignment @SupplierSurname = Yev
EXECUTE GetConsignment 1234

SELECT * FROM Consignments

-----------------------------------------------------------------------------------------------------------
--UPDATE

CREATE PROCEDURE UpdateConsignment
	@Number BIGINT,
	@SupplierID BIGINT = NULL,
	@RecipientID BIGINT = NULL,
	@ConsigmentDate DATETIME = NULL
AS
BEGIN
	SET NOCOUNT ON;
	IF (@Number IS NOT NULL) AND EXISTS 
	(
		SELECT * 
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN
	IF (@SupplierID IS NOT NULL) and EXISTS 
	(
			SELECT * 
			FROM Individuals
			WHERE IPN = @SupplierID
	) 
	BEGIN
	UPDATE [dbo].[Consignments]
	SET SupplierID = @SupplierID
	WHERE Number= @Number
	END

	IF (@RecipientID IS NOT NULL) and EXISTS 
	(
			SELECT * 
			FROM Individuals
			WHERE IPN = @RecipientID
	) 
	BEGIN
	UPDATE [dbo].[Consignments]
	SET RecipientID = @RecipientID
	WHERE Number = @Number
	END

	IF (@ConsigmentDate IS NOT NULL) 
	BEGIN
	UPDATE [dbo].[Consignments]
	SET ConsignmentDate = @ConsigmentDate
	WHERE Number= @Number
	END
END
END
GO


--TEST
EXECUTE UpdateConsignment 1252, 3, 4

SELECT * FROM Consignments

-------------------------------------------------------------------------------------------------
--REMOVE

CREATE PROCEDURE RemoveConsignment
	@Number BIGINT
AS
BEGIN
    IF(@Number IS NOT NULL) AND EXISTS
	(
		SELECT *
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN

	DELETE FROM Orders
	WHERE ConsignmentNumber = @Number

	DELETE FROM Consignments
	WHERE Number = @Number 
	END
END
GO

--TEST
EXECUTE RemoveConsignment 1236

SELECT * FROM Consignments
SELECT * FROM Orders

-------------------------------------------------------------------------------------------------------------