ALTER TABLE Orders
ADD SerialNumder TINYINT NOT NULL DEFAULT '0'

UPDATE Orders
SET SerialNumder = 1
WHERE ProductID = 1

UPDATE Orders
SET SerialNumder = 2
WHERE ProductID = 2

UPDATE Orders
SET SerialNumder = 3
WHERE ProductID = 3

UPDATE Orders
SET SerialNumder = 4
WHERE ProductID = 4

UPDATE Orders
SET SerialNumder = 5
WHERE ProductID = 5

UPDATE Orders
SET SerialNumder = 6
WHERE ProductID = 6

SELECT * FROM Orders


 SELECT O.ConsignmentNumber, O.ProductID, O.Amount 
 FROM Orders O
 WHERE O.ProductID IN
	(
	SELECT P.ID
	FROM Products P
	WHERE P.Price > 100
	)
ORDER BY O.ConsignmentNumber, O.SerialNumder

SELECT * FROM Orders
ORDER BY ConsignmentNumber