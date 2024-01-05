-- =============================================
-- Author:		<Koval Kate>
-- Create date: <18.03.2023>
-- Description:	<CRUD operations to Consignments>
-- =============================================

-- CREATE

CREATE PROCEDURE AddIndividual
	@IndividualID BIGINT,
	@IndividualName NVARCHAR(20),	
	@IndividualSurname NVARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	IF NOT EXISTS	
	(
		SELECT IPN 
		FROM Individuals
		WHERE IPN = @IndividualID
	) 
	BEGIN 
		INSERT INTO [dbo].[Individuals]
		VALUES (@IndividualID, @IndividualName, @IndividualSurname)
	END
END
GO

CREATE PROCEDURE AddConsignment
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
		SELECT Number 
		FROM Consignments
		WHERE Number = @Number
	)
	AND (@SupplierID IS NOT NULL) AND (@RecipientID IS NOT NULL) AND @SupplierID LIKE '_' AND @RecipientID LIKE '_'
	BEGIN
		EXECUTE AddIndividual @SupplierID, @SupplierName, @SupplierSurname
	END
	BEGIN
		EXECUTE AddIndividual @RecipientID, @RecipientName, @RecipientSurname
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
DROP PROCEDURE AddConsignment2;
GO

CREATE PROCEDURE AddConsignment2
	@Number BIGINT,
	@SupplierID BIGINT = NULL,
	@RecipientID BIGINT = NULL,
	@ConsigmentDate DATETIME = NULL,
	@SupplierName NVARCHAR(20) = NULL,
	@SupplierSurname NVARCHAR(20) = NULL,
	@RecipientName NVARCHAR(20) = NULL,
	@RecipientSurname NVARCHAR(20) = NULL,
	@AddedConsigmentNumber BIGINT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	IF (@Number IS NULL) OR EXISTS 
	(
		SELECT Number 
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN
		RETURN 1
	END

	IF((@SupplierID IS NULL AND (@SupplierName IS NULL OR @SupplierSurname IS NULL)) 
		OR (@RecipientID IS NULL AND (@RecipientName IS NULL OR @RecipientSurname IS NULL)))
	BEGIN
		RETURN 2
	END	
		
		
	IF(@SupplierID IS NULL)
	BEGIN
		SELECT @SupplierID = IPN
		FROM Individuals
		WHERE Name = @SupplierName AND Surname = @SupplierSurname
	END

	IF(@SupplierID IS NULL)
	BEGIN
		RETURN 3
	END

	IF(@RecipientID IS NULL)
	BEGIN
		SELECT @RecipientID = IPN
		FROM Individuals
		WHERE Name = @RecipientName AND Surname = @RecipientSurname
	END

	IF(@RecipientID IS NULL)
	BEGIN
		RETURN 4
	END


	IF (@SupplierID IS NOT NULL) and NOT EXISTS 
	(
		SELECT * 
		FROM Individuals
		WHERE IPN = @SupplierID
	) 
	BEGIN
		RETURN 5
	END

	IF (@RecipientID IS NOT NULL) and NOT EXISTS 
	(
		SELECT * 
		FROM Individuals
		WHERE IPN = @RecipientID
	) 
	BEGIN
		RETURN 6
	END
			
	-------------------------
	--VALIDATE @ConsigmentDate

	IF @ConsigmentDate IS NULL
	BEGIN
		SET @ConsigmentDate = GETDATE();
	END
	--------------------------
	INSERT INTO [dbo].[Consignments]
	VALUES
		(@Number, @ConsigmentDate, @SupplierID,@RecipientID)

	SET @AddedConsigmentNumber = @Number
	RETURN 0
END
GO

--Test
DECLARE @ResultAddedConsigmentNumber BIGINT;

EXECUTE AddConsignment2 1259, @SupplierName = 'Alexey', @SupplierSurname = 'Azarenko'
							, @RecipientName = 'Roman', @RecipientSurname = 'Evsenev', @AddedConsigmentNumber = @ResultAddedConsigmentNumber OUTPUT
							
PRINT @ResultAddedConsigmentNumber
SELECT Number, ConsignmentDate, SupplierID, RecipientID
FROM Consignments
WHERE Number = @ResultAddedConsigmentNumber

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

	SELECT Number, ConsignmentDate, SupplierID, RecipientID
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

DROP PROCEDURE UpdateConsignment
GO

CREATE PROCEDURE UpdateConsignment
	@Number BIGINT,
	@SupplierID BIGINT = NULL,
	@RecipientID BIGINT = NULL,
	@ConsigmentDate DATETIME = NULL,
	@SupplierName NVARCHAR(20) = NULL,
	@SupplierSurname NVARCHAR(20) = NULL,
	@RecipientName NVARCHAR(20) = NULL,
	@RecipientSurname NVARCHAR(20) = NULL,
	@AddedConsigmentNumber BIGINT = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	IF (@Number IS NULL) OR	NOT EXISTS 
	(
		SELECT Number 
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN
		RETURN 1
	END

	IF((@SupplierID IS NULL AND (@SupplierName IS NULL OR @SupplierSurname IS NULL)) 
		OR (@RecipientID IS NULL AND (@RecipientName IS NULL OR @RecipientSurname IS NULL)))
	BEGIN
		RETURN 2
	END	
		
		
	IF(@SupplierID IS NULL)
	BEGIN
		SELECT @SupplierID = IPN
		FROM Individuals
		WHERE Name = @SupplierName AND Surname = @SupplierSurname
	END

	IF(@SupplierID IS NULL)
	BEGIN
		RETURN 3
	END

	IF(@RecipientID IS NULL)
	BEGIN
		SELECT @RecipientID = IPN
		FROM Individuals
		WHERE Name = @RecipientName AND Surname = @RecipientSurname
	END

	IF(@RecipientID IS NULL)
	BEGIN
		RETURN 4
	END


	IF (@SupplierID IS NOT NULL) and NOT EXISTS 
	(
		SELECT * 
		FROM Individuals
		WHERE IPN = @SupplierID
	) 
	BEGIN
		RETURN 5
	END

	IF (@RecipientID IS NOT NULL) and NOT EXISTS 
	(
		SELECT * 
		FROM Individuals
		WHERE IPN = @RecipientID
	) 
	BEGIN
		RETURN 6
	END
			
	-------------------------
	--VALIDATE @ConsigmentDate

	IF @ConsigmentDate IS NULL
	BEGIN
		SET @ConsigmentDate = GETDATE();
	END
	UPDATE [dbo].[Consignments]	
	SET SupplierID = ISNULL(@SupplierID, SupplierID),
		RecipientID = ISNULL(@RecipientID, RecipientID),
		ConsignmentDate = ISNULL(@ConsigmentDate, ConsignmentDate)
	WHERE Number= @Number
	
	RETURN 0

END
GO


--TEST
EXECUTE UpdateConsignment 1234, 3, 4

SELECT * FROM Consignments

-------------------------------------------------------------------------------------------------
--REMOVE
--ограничить по времени (update)
--soft delete


--SET CONTEXT_INFO 1;  --binary
--GO  
--SELECT CONTEXT_INFO();  
--GO  

DROP PROCEDURE RemoveConsignment
GO 

CREATE PROCEDURE RemoveConsignment
	@Number BIGINT,
	@DateInterval TINYINT = 1,
	@ErrorStatus INT OUTPUT
AS
BEGIN
    IF(@Number IS NULL) OR NOT EXISTS
	(
		SELECT *
		FROM Consignments
		WHERE Number = @Number
	)
	BEGIN
		SET @ErrorStatus = 1
		RETURN 1
	END

	DECLARE @RemovedConsigmentDate DATETIME

	SELECT @RemovedConsigmentDate = ConsignmentDate
	FROM Consignments
	WHERE Number = @Number

	IF(@RemovedConsigmentDate > DATEADD(DAY, @DateInterval, GETDATE()))
	BEGIN
	SET @ErrorStatus = 2
		RETURN 2
	END

	DELETE FROM Orders
	WHERE ConsignmentNumber = @Number

	DELETE FROM Consignments
	WHERE Number = @Number 

	SET @ErrorStatus = 0
	RETURN 0

END
GO

--TEST
DECLARE @ResultOperationStatus INT 

EXECUTE @ResultOperationStatus = RemoveConsignment 1222

PRINT @ResultOperationStatus
SELECT * FROM Consignments
SELECT * FROM Orders

-------------------------------------------------------------------------------------------------------------