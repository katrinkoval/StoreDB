USE Store;
GO

SELECT * FROM Consignments

SELECT Number, SupplierID, RecipientID FROM Consignments

SELECT * FROM Orders

SELECT * FROM Orders
	WHERE ConsignmentNumber=1236 OR ConsignmentNumber=1235

SELECT * FROM Orders
	WHERE ConsignmentNumber IN (1235, 1236) AND Amount > 3

SELECT * FROM Orders
	WHERE ConsignmentNumber NOT IN (1235, 1236)

SELECT ConsignmentNumber, SUM(Amount) AS AmountOfProduct 
FROM Orders
GROUP BY ConsignmentNumber

SELECT ProductID, SUM(Amount) AS ProductAmount 
FROM Orders
WHERE ConsignmentNumber NOT IN (1238, 1239)
GROUP BY ProductID

SELECT * FROM Products

SELECT UnitID, COUNT(Name) AS AmountOfProducts 
FROM Products
GROUP BY UnitID

SELECT UnitID, MIN(Price) AS MinPrice 
FROM Products
GROUP BY UnitID

SELECT UnitID, MAX(Price) AS MaxPrice 
FROM Products
GROUP BY UnitID
HAVING MAX(Price) > 1500		