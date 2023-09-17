
INSERT INTO [dbo].[Consignments]
           ([Number]
           ,[ConsignmentDate]
           ,[SupplierID]
           ,[RecipientID])
     VALUES
           (001240, DATEADD(MONTH, -8, GETDATE()), 0001, 0002),
		   (001241, DATEADD(MONTH, -2, GETDATE()), 0001, 0003),
		   (001242, DATEADD(MONTH, -3, GETDATE()), 0002, 0003),
		   (001243, DATEADD(MONTH, -7, GETDATE()), 0003, 0004),
		   (001244, DATEADD(MONTH, -5, GETDATE()), 0004, 0001)

GO

INSERT INTO [dbo].[Orders]
           ([ConsignmentNumber]
           ,[ProductID]
           ,[Amount])
     VALUES
           (001240, 3, 7),
		   (001242, 2, 3),
		   (001242, 1, 15),
		   (001243, 4, 2),
		   (001243, 3, 9),
		   (001244, 5, 2),
		   (001244, 6, 3),
		   (001240, 3, 17),
		   (001241, 4, 2),
		   (001241, 2, 8)
GO


DECLARE @ReportYear DATETIME = 2023;
SELECT P.Name,
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=1 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "January",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=2 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "February",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=3 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "March",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=4 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "April",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=5 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "May",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=6 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "June",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=7 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "July",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=8 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "August",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=9 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "September",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=10 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "October",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=11 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "November",
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=12 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END) AS "December",
SUM(CASE WHEN O.Amount!= 0 THEN O.Amount ELSE 0 END) AS "Total"
FROM Products P
LEFT JOIN Orders O On P.ID = O.ProductID
LEFT JOIN Consignments C on O.ConsignmentNumber = C.Number
GROUP BY P.Name
UNION 
SELECT '_TOTAL',
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=1 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END), 
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=2 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=3 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END), 
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=4 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=5 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=6 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=7 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=8 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=9 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=10 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=11 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN datepart(month,C.ConsignmentDate)=12 and datepart(year, C.ConsignmentDate) = @ReportYear THEN O.Amount ELSE 0 END),
SUM(CASE WHEN O.Amount!= 0 THEN O.Amount ELSE 0 END)
FROM Orders O
LEFT JOIN Consignments C ON O.ConsignmentNumber = C.Number
ORDER BY P.Name



