USE Store
GO

SELECT ConsignmentNumber, Name
FROM Orders JOIN Products ON ProductID = ID
ORDER BY ConsignmentNumber

INSERT INTO [dbo].[Products]
           ([ID]
           ,[Name]
           ,[UnitID]
           ,[Price])
     VALUES
           (7, 'NewProduct1', 2, 500),
		   (8, 'NewProduct2', 3, 700)
GO

SELECT ConsignmentNumber, Name
FROM Orders LEFT JOIN Products ON ProductID = ID

SELECT ConsignmentNumber, Name
FROM Orders RIGHT JOIN Products ON ProductID = ID

SELECT ConsignmentNumber, Name
FROM Products FULL JOIN Orders ON ProductID = ID

SELECT C.Number, C.ConsignmentDate, I1.Name + ' ' + I1.Surname AS Supplier, I2.Name + ' ' + I2.Surname AS Recipient
		, P.Name, U.UnitType, O.Amount, P.Price, P.Price * O.Amount AS FinalPrice 
FROM Consignments C
		JOIN Orders O ON C.Number = O.ConsignmentNumber 
		JOIN Products P ON O.ProductID = P.ID
		JOIN Units U ON P.UnitID = U.ID
		JOIN Individuals I1 ON C.SupplierID = I1.IPN
		JOIN Individuals I2 ON C.RecipientID = I2.IPN;


SELECT C.Number, C.ConsignmentDate, I1.Name + ' ' + I1.Surname AS Supplier, I2.Name + ' ' + I2.Surname AS Recipient
		, P.Name, U.UnitType, O.Amount, P.Price, P.Price * O.Amount AS FinalPrice 
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
		LEFT JOIN Units U ON P.UnitID = U.ID
		LEFT JOIN Individuals I1 ON C.SupplierID = I1.IPN
		LEFT JOIN Individuals I2 ON C.RecipientID = I2.IPN



SELECT C.Number, P.Name, P.Price		
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
UNION 
SELECT C.Number,'Total price', SUM(O.Amount * P.Price)
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
GROUP BY C.Number