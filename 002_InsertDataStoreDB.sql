USE master
GO

USE Store
GO

INSERT INTO [dbo].[Units]
           ([ID]
           ,[UnitType])
     VALUES
          (1, 'Meter'),
		  (2, 'Kilo'),
		  (3, 'Liter'),
		  (4, 'Unit')
GO

INSERT INTO [dbo].[Products]
           ([ID]
           ,[Name]
           ,[UnitID]
           ,[Price])
     VALUES
           (1, 'Ñement', 2, 1200),
		   (2, 'Paint', 3, 1500),
		   (3, 'Sand', 2, 700),
		   (4, 'Grid', 1, 2100),
		   (5, 'Door', 4, 2500),
		   (6, 'Glue', 3, 1000)
GO

INSERT INTO [dbo].[Individuals]
           ([IPN]
           ,[Name]
           ,[Surname])
     VALUES
           (0001, 'Roman', 'Evsenev'),
		   (0002, 'Anastasia', 'Gonchar'),
		   (0003, 'Margarita', 'Babak'),
		   (0004, 'Alexey', 'Azarenko')
GO

INSERT INTO [dbo].[Consignments]
           ([Number]
           ,[ConsignmentDate]
           ,[SupplierID]
           ,[RecipientID])
     VALUES
           (1234, DATEADD(DAY, -5, GETDATE()), 0001, 0002),
		   (1235, DATEADD(DAY, -4, GETDATE()), 0001, 0003),
		   (1236, DATEADD(DAY, -3, GETDATE()), 0002, 0003),
		   (1237, DATEADD(DAY, -2, GETDATE()), 0003, 0004),
		   (1238, DATEADD(DAY, -1, GETDATE()), 0004, 0001),
		   (1239, GETDATE(), 0003, 0002)

GO

INSERT INTO [dbo].[Orders]
           ([ConsignmentNumber]
           ,[ProductID]
           ,[Amount])
     VALUES
           (1236, 3, 10),
		   (1237, 2, 3),
		   (1239, 1, 5),
		   (1239, 4, 2),
		   (1235, 3, 7),
		   (1236, 5, 21),
		   (1236, 6, 3),
		   (1235, 3, 17),
		   (1236, 4, 2),
		   (1238, 2, 7)
GO




SELECT * FROM Consignments
SELECT * FROM Individuals
SELECT * FROM Orders
SELECT * FROM Products
SELECT * FROM Units

