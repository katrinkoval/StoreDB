USE Store;
GO

SELECT DISTINCT SupplierID, RecipientID
FROM Consignments

SELECT DISTINCT ConsignmentNumber, ProductID
FROM Orders
ORDER BY ConsignmentNumber DESC

SELECT DISTINCT SupplierID, Date
FROM Consignments
ORDER BY Date DESC
