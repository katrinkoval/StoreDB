USE Store
GO

CREATE VIEW ActualPriceList (Price, ID, Dates)		--WITH ENCRYPTION
AS SELECT PPU.NewPrice, PPU.ProductID, PPU.UpdateDate
FROM ProductPriceUpdates PPU
WHERE (PPU.UpdateDate IS NOT NULL AND PPU.UpdateDate =
	(
		SELECT MAX(PPU1.UpdateDate)
		FROM ProductPriceUpdates PPU1
		WHERE PPU.ProductID = PPU1.ProductID
		) 
	)
OR (PPU.UpdateDate IS NULL AND NOT EXISTS
	(
		SELECT UpdateDate
		FROM ProductPriceUpdates PPU1
		WHERE PPU.ProductID = PPU1.ProductID AND PPU1.UpdateDate IS NOT NULL
	)
)

CREATE VIEW AllConsigmentsCompleteInfo (Number, Date, Supplier, Recipient, Product, UnitType, Amount, Price, FinalPrice)
AS SELECT C.Number, C.ConsignmentDate, I1.Name + ' ' + I1.Surname, I2.Name + ' ' + I2.Surname
		, P.Name, U.UnitType, O.Amount, P.Price, P.Price * O.Amount
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
		LEFT JOIN Units U ON P.UnitID = U.ID
		LEFT JOIN Individuals I1 ON C.SupplierID = I1.IPN
		LEFT JOIN Individuals I2 ON C.RecipientID = I2.IPN


CREATE VIEW TotalPriceToAllConsigments (Number, Product, Price)
AS SELECT C.Number, P.Name, P.Price		
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
UNION 
SELECT C.Number,'Total price', SUM(O.Amount * P.Price)
FROM Consignments C
		LEFT JOIN Orders O ON C.Number = O.ConsignmentNumber 
		LEFT JOIN Products P ON O.ProductID = P.ID
GROUP BY C.Number
