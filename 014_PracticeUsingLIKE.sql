USE STORE
GO

SELECT IPN, Name, Surname
FROM Individuals
WHERE Surname LIKE 'B%'

SELECT IPN, Name, Surname
FROM Individuals
WHERE Surname LIKE '[A-E]%'

SELECT IPN, Name, Surname
FROM Individuals
WHERE Surname LIKE '[^A-E]%'

SELECT Number, ConsignmentDate
FROM Consignments
WHERE Number LIKE '__4_'

SELECT ID, Name, Price
FROM Products
WHERE Price LIKE '1%'

SELECT O.ConsignmentNumber, P.Name, P.Price, O.Amount, P.Price * O.Amount AS Total
FROM Orders O
LEFT JOIN Products P ON O.ProductID = P.ID
WHERE P.Price * O.Amount LIKE '1___%'

