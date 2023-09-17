 USE Store
 GO

 -- select all products in consignment that have a price > 1000
 SELECT ConsignmentNumber, ProductID, Amount 
 FROM Orders
 WHERE ProductID IN
	(
	SELECT ID
	FROM Products
	WHERE Price > 1000
	)

 --correlated subquery
 SELECT ConsignmentNumber, ProductID, Amount 
 FROM Orders ord
 WHERE EXISTS
	( 
		SELECT ID 
		FROM Products pr
		WHERE ord.ProductID = pr.ID AND pr.Price > 1000
	)


DECLARE @StartDate DATETIME = '2023-08-22';

DECLARE @FinishDate DATETIME;
SET @FinishDate = '2023-08-25 23:59:59';

--select products which were ordered during a specified time frame
SELECT P.ID, P.Name, P.Price
FROM Products P
WHERE ID IN
	(
		SELECT ProductID
		FROM Orders O
		WHERE ConsignmentNumber IN
			(
				SELECT Number
				FROM Consignments
				WHERE ConsignmentDate BETWEEN @StartDate AND @FinishDate
			)
	)

--correlated subquery
SELECT ID, Name, Price		
FROM Products P 
WHERE EXISTS
	(
		SELECT ProductID
		FROM Orders O
		WHERE P.ID = O.ProductID AND EXISTS
			(
				SELECT Number
				FROM Consignments C
				WHERE O.ConsignmentNumber = C.Number 
					AND ConsignmentNumber BETWEEN @StartDate AND @FinishDate
			)
	)

--select products which were ordered during a specified time frame	JOINS
SELECT P.ID, P.Name, P.Price
FROM Products P 
LEFT JOIN Orders O ON O.ProductID = P.ID
LEFT JOIN Consignments C ON C.Number = O.ConsignmentNumber
WHERE ConsignmentDate BETWEEN @StartDate AND @FinishDate

--select products which were ordered during a specified time frame	JOINS
SELECT P.ID, SUM(O.Amount) AS Amount, SUM(O.Amount * P.Price) AS TotalPrice
FROM Products P 
LEFT JOIN Orders O ON O.ProductID = P.ID
LEFT JOIN Consignments C ON C.Number = O.ConsignmentNumber
WHERE ConsignmentDate BETWEEN @StartDate AND @FinishDate
GROUP BY P.ID

--select latest consignment for each supplier
SELECT *			
FROM Consignments cons		
WHERE cons.ConsignmentDate = 
		(
			SELECT MAX(consDate.ConsignmentDate)
			FROM Consignments consDate
			WHERE cons.SupplierID = consDate.SupplierID
		)
ORDER BY CONS.Number

