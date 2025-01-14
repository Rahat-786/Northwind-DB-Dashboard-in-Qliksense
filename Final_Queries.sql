/**SELECT *
FROM Employees;
**/


--- Get all columns from the tables Customers, Orders, and suppliers

SELECT * 
FROM Customers, Orders, Suppliers;


-- Get all customers alphabetically by Country and name

SELECT CustomerID, CompanyName, Country 
FROM CUSTOMERS
ORDER BY Country, CompanyName;

--- Get all orders by date
SELECT * 
FROM Orders
ORDER BY OrderDate;

-- Get the count of all orders made during 1997

SELECT COUNT(OrderID) OrderCount
FROM Orders
WHERE YEAR(OrderDate) = 1997;


--- Get the names of all the contact persons where the person is a manager, alphabetically
--- The report should only return rows for which the total number of orders is greater than 15

SELECT * FROM Orders;

SELECT 
	c.CustomerID,
	COUNT(o.OrderID) Total_Orders
FROM Orders o
LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE OrderDate > '1996-12-31'
GROUP BY c.CustomerID
HAVING COUNT(o.OrderID) > 15;










------------------------------ TRANSACTION SQL --------------------------------

---------------------- INSERTION --------------------------

---- Insert yourself into the Employees table
 --- Include the following fields: LastName, FirstName, Title, TitleOfCourtesy, BirthDate,
-- HireDate, City, Region, PostalCode, Country, HomePhone, ReportsTo

BEGIN TRANSACTION;

INSERT INTO Employees (LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, City, Region, PostalCode, Country, HomePhone, ReportsTo)
 --- Include the following fields: CustomerID, EmployeeID, OrderDate, RequiredDate

 SELECT * FROM Orders;

 INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate)
 VALUES ('PKRKH', 11, '2024-12-16 00:00:00.000', '2024-12-20 00:00:00.000');


 /** The above query was throwing an error on the violation of the foreign key. The below query inserts the customerID first 
 in the customer table so that the values can be added into the Orders table. **/

 INSERT INTO Customers (CustomerID, CompanyName)
 VALUES ('PKRKH', 'TMC');

 SELECT * FROM Customers WHERE CustomerID = 'PKRKH';


 --- Insert order details in the Order_Details table
--- Include the following fields: OrderID, ProductID, UnitPrice, Quantity, Discount

INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES ('11083', 34, 78.12, 10, 0.25);

SELECT * FROM [Order Details];


------------------------------------------------------------------------------------------------------------------------------
--------------------------------------- UPDATING RECORDS ---------------------------------------------------------------------

---  Update the phone of yourself (from the previous entry in Employees table) 

UPDATE Employees
SET HomePhone = '0333-1022900'
WHERE EmployeeID = 11;


SELECT * FROM Employees;


--- 2. Double the quantity of the order details record you inserted before 

UPDATE [Order Details]
SET Quantity = 20
WHERE OrderID = 11079;

SELECT * FROM [Order Details] WHERE OrderID = 11083;


---  Repeat previous update but this time update all orders associated with you

UPDATE [Order Details]
SET UnitPrice = 79.00, Quantity = 30, Discount = 0.2
WHERE OrderID = 11083;


SELECT * FROM [Order Details] WHERE OrderID = 11083;


--------------------------------------------------------------------------------------------------------------------------
--------------------------------- DELETING RECORDS -----------------------------------------------------------------------


---- Delete the records you inserted before. Don't delete any other records!

--- Deleting records from Employees Table
 ROLLBACK;

 SELECT * FROM Employees WHERE EmployeeID = 11;
 SELECT * FROM Orders WHERE EmployeeID = 11;
 SELECT * FROM [Order Details] WHERE OrderID = 11083;



 --------------------------------------------------------------------------------------------------------------------------------

-------------------------------------- ADVANCE QUERIES --------------------------------------------------------------------------

----- What were our total revenues in 1997 (Result must be 617.085,27)


SELECT ROUND(SUM(o2.UnitPrice * o2.Quantity * (1 - o2.Discount)), 4) Revenue
FROM [Order Details] o2
INNER JOIN Orders o1 ON o2.OrderID = o1.OrderID
WHERE YEAR(o1.OrderDate) = '1997';



--- What is the total amount each customer has payed us so far (Hint: QUICK-Stop has payed us 110.277,32)

SELECT * FROM Customers;

SELECT * FROM [Order Details];

SELECT * FROM Orders WHERE CustomerID = 'QUICK';

SELECT o1.CustomerID, o1.ShipName, SUM(o2.UnitPrice * o2.Quantity * (1 - o2.Discount)) Amount_Payed
FROM Orders o1
LEFT JOIN [Order Details] o2 ON o1.OrderID = o2.OrderID
WHERE o1.ShipName = 'QUICK-Stop'
GROUP BY o1.CustomerID, o1.ShipName
ORDER BY Amount_Payed DESC;



---- Find the 10 top selling products (Hint: Top selling product is "C�te de Blaye")

SELECT * FROM Products;

SELECT TOP 10 p.ProductID, p.ProductName, SUM(o.UnitPrice * o.Quantity * (1-o.Discount)) Revenue
FROM Products p
LEFT JOIN [Order Details] o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY Revenue DESC;


----  Create a view with total revenues per customer

SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM [Order Details];

CREATE VIEW Revenue AS 
SELECT c.CustomerID, SUM(o2.UnitPrice * o2.Quantity * (1-o2.Discount)) Total_Revenue
FROM Customers c
INNER JOIN Orders o1 ON c.CustomerID = o1.CustomerID
INNER JOIN [Order Details] o2 on o1.OrderID = o2.OrderID
GROUP BY c.CustomerID;

--- Let's see our view

SELECT * FROM Revenue;


--- Which UK Customers have payed us more than 1000 dollars


SELECT c.CustomerID, c.CompanyName, c.Country, SUM(o1.UnitPrice * o1.Quantity * (1-o1.Discount)) Amount_Payed
FROM Customers c
JOIN Orders o2 ON c.CustomerID = o2.CustomerID
JOIN [Order Details] o1 ON o1.OrderID = o2.OrderID
WHERE c.Country = 'UK' 
GROUP BY c.CustomerID, c.CompanyName, c.Country
HAVING SUM(o1.UnitPrice * o1.Quantity * (1-o1.Discount)) > 1000
ORDER BY Amount_Payed DESC;



/**  How much has each customer payed in total and how much in 1997. We want one result set with the following columns:
CustomerID
CompanyName
Country
Customer's total from all orders
Customer's total from 1997 orders

**/

SELECT c.CustomerID, c.CompanyName, c.Country, SUM(s.Subtotal) AS Total_Revenue, SUM(CASE WHEN YEAR(o.OrderDate) = 1997 THEN s.Subtotal ELSE 0 END) AS Revenue_1997
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
LEFT JOIN [Order Subtotals] s ON o.OrderID = s.OrderID
GROUP BY c.CustomerID, c.CompanyName, c.Country
ORDER BY Total_Revenue DESC;