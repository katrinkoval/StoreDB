
DECLARE @ReportYear DATETIME = 2023;

IF Object_ID ('TempDB..#YearReport') IS NOT NULL
SELECT * FROM #YearReport
ELSE
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
INTO #YearReport
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

