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


--- Get the names of all the contact persons where the person is a manager, alphabeticallySELECT EmployeeID, FirstName, LastName, TitleFROM EmployeesWHERE Title like '%Manager'ORDER BY FirstName, LastName;--- Get all orders placed on the 19th of May, 1997SELECT OrderID, OrderDateFROM OrdersWHERE OrderDate = '1997-05-19';---------------------------------------------------------------------------------------------------------------------------------------------- JOINS ---------------------------------------------------------------- Create a report for all the orders of 1996 and their Customers (152 rows)SELECT o.OrderID, o.OrderDate, c.CustomerID, c.CompanyNameFROM Orders oLEFT JOIN Customers c ON o.CustomerID = c.CustomerIDWHERE YEAR(o.OrderDate) = '1996';---- Create a report that shows the number of employees and customers from each city that has employees in it SELECT e.City, COUNT(DISTINCT e.EmployeeID) Total_Employees, COUNT(Distinct c.CustomerID) Total_CustomersFROM Employees eLEFT JOIN Customers c ON e.City = c.CityGROUP BY e.CityHAVING COUNT(DISTINCT e.City) > 0ORDER BY e.City;---- Create a report that shows the number of employees and customers from each city that has customers in itSELECT c.City City, COUNT(DISTINCT e.EmployeeID) Employees, COUNT(c.CustomerID) CustomersFROM Customers cLEFT JOIN Employees e on c.City = e.CityGROUP BY c.CityHAVING COUNT(DISTINCT c.CustomerID) > 0ORDER BY c.City;--- Create a report that shows the number of employees and customers from each citySELECT	COALESCE(e.City, c.City) City,	COUNT(DISTINCT e.EmployeeID) Employees,	COUNT(DISTINCT c.CustomerID) CustomersFROM Employees eFULL OUTER JOIN Customers c ON e.City = c.CityGROUP BY COALESCE(e.City, c.City)ORDER BY City;---------------------------------------------------------------------------------------------------------------------------------------------------------------- HAVING ------------------------------------------------------------------- Create a report that shows the order ids and the associated employee names for orders that shipped after the required dateSELECT * FROM Orders;SELECT * FROM Employees;SELECT o.OrderID, e.FirstName, e.LastNameFROM Orders oINNER JOIN Employees e ON o.EmployeeID = e.EmployeeIDWHERE o.ShippedDate > o.RequiredDateGROUP BY o.OrderID, e.FirstName, e.LastNameHAVING COUNT(DISTINCT o.OrderID) > 0;---- Create a report that shows the total quantity of products (from the Order_Details table) ordered. --- Only show records for products for which the quantity ordered is fewer than 200 SELECT p.ProductName, SUM(o.Quantity) Total_QuantityFROM [Order Details] oLEFT JOIN Products p ON o.ProductID = p.ProductIDGROUP BY p.ProductNameHAVING SUM(o.Quantity) < 200;---  Create a report that shows the total number of orders by Customer since December 31,1996. 
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

INSERT INTO Employees (LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, City, Region, PostalCode, Country, HomePhone, ReportsTo) VALUES ('Qayyum', 'Rahat', 'BI Analyst', 'Ms.', '2001-07-11 00:00:00.000', '2024-10-01', 'Karachi', 'Sindh', '75950', 'Pakistan','0321-1478093', 5); SELECT * FROM Employees WHERE FirstName = 'Rahat'; SELECT * FROM Employees; ----  Insert an order for yourself in the Orders table
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



---- Find the 10 top selling products (Hint: Top selling product is "Côte de Blaye")

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
