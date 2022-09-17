USE adventureworks2019;

/*
select
from
where
group by
having
order by
limit
*/

SELECT customerid, COUNT(*), SUM(subtotal) AS subtotal1
FROM sales_salesorderheader
WHERE onlineorderflag = 0
GROUP BY customerid
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC
LIMIT 100;

SELECT *
FROM sales_salesorderdetail
WHERE 1=0;

-- join

SELECT soh.SalesOrderID, orderdate, onlineorderflag, customerid, subtotal, totaldue, sod.SalesOrderID, salesorderdetailid, orderqty, linetotal
FROM sales_salesorderheader soh JOIN sales_salesorderdetail sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE 1=1;

SELECT * FROM sales_customer;

SELECT soh.SalesOrderID, orderdate, onlineorderflag, customerid, subtotal, totaldue, sod.SalesOrderID, salesorderdetailid, pp.ProductID, pp.NAME, orderqty, linetotal
FROM sales_salesorderheader soh JOIN sales_salesorderdetail sod
ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product pp
ON sod.ProductID = pp.ProductID
WHERE 1=1;

SELECT soh.SalesOrderID, orderdate, onlineorderflag, sc.CustomerID, subtotal, totaldue, sod.SalesOrderID, salesorderdetailid, pp.ProductID, pp.NAME, orderqty, linetotal
FROM sales_salesorderheader soh JOIN sales_salesorderdetail sod
ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product pp
ON sod.ProductID = pp.ProductID
JOIN sales_customer sc
ON soh.CustomerID = sc.CustomerID
WHERE 1=1;

-- inner join outer join

CREATE TABLE b (
  id int unsigned not null,
  istorename varchar(50) not null
);

INSERT INTO b VALUES(3, 'store3');
INSERT INTO b VALUES(4, 'store4');
INSERT INTO b VALUES(5, 'store5');
INSERT INTO b VALUES(6, 'store6');

select * from a ;
select * from b ;

-- inner join

SELECT *
FROM a inner join b
on a.id = b.id;

-- outer join

SELECT *
FROM a left outer join b
on a.id = b.id;

SELECT *
FROM a right outer join b
on a.id = b.id;

CREATE TABLE a (
  id int unsigned not null,
  iname varchar(50) not null
);

INSERT INTO a VALUES(1, 'apple');
INSERT INTO a VALUES(2, 'banana');
INSERT INTO a VALUES(3, 'peach');
INSERT INTO a VALUES(4, 'pineapple');

select * from a ;

-- --------------------

SELECT sod.ProductID, pp.ProductID, pp.Name
FROM sales_salesorderdetail sod RIGHT OUTER JOIN production_product pp
ON sod.ProductID = pp.ProductID
WHERE sod.ProductID IS NULL;

-- --------------------

-- union

--  실습 테이블 만들기 

select * from purchasing_purchaseorderheader;
select min(OrderDate), max(OrderDate) from purchasing_purchaseorderheader;

CREATE TABLE IF NOT EXISTS purchasing_purchaseorderheader2011 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader
where year(orderdate) = 2011;

-- select * from purchasing_purchaseorderheader2011;

CREATE TABLE IF NOT EXISTS purchasing_purchaseorderheader2012 
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_purchaseorderheader
where year(orderdate) = 2012;

-- select * from purchasing_purchaseorderheader2012;

-- 컬럼을 일부로 누락한 테이블 RevisionNumber 컬럼을 제거
CREATE TABLE IF NOT EXISTS purchasing_purchaseorderheader2013 
select purchaseOrderID, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue  
from purchasing_purchaseorderheader
where year(orderdate) = 2013;

-- 뒷 부분 컬럼을 추가한 테이블 
CREATE TABLE IF NOT EXISTS purchasing_purchaseorderheader2014
select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue, 'dummy'
from purchasing_purchaseorderheader
where year(orderdate) = 2014;

-- --------------------

select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2011
UNION
select purchaseOrderID, RevisionNumber, status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2012;

-- --------------------

select status, employeeID
from purchasing_PurchaseOrderHeader2011
UNION ALL
select status, employeeID 
from purchasing_PurchaseOrderHeader2012;

-- --------------------

select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2011
UNION
select purchaseOrderID, 0             , status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2013;

-- --------------------

select purchaseOrderID, RevisionNumber, status, employeeID
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2011
UNION
select purchaseOrderID, RevisionNumber, status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2012
UNION ALL
select purchaseOrderID, 0             , status, employeeID 
, VendorID, ShipMethodID, Orderdate
, SubTotal, TaxAmt, Freight, TotalDue
from purchasing_PurchaseOrderHeader2013;

-- --------------------

SHOW COLUMNS FROM purchasing_PurchaseOrderHeader2013;

-- --------------------

CREATE VIEW vw_2011_to_2013
AS
(
	select purchaseOrderID, RevisionNumber, status, employeeID
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from purchasing_PurchaseOrderHeader2011
	UNION
	select purchaseOrderID, RevisionNumber, status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from purchasing_PurchaseOrderHeader2012
	UNION ALL
	select purchaseOrderID, 0             , status, employeeID 
	, VendorID, ShipMethodID, Orderdate
	, SubTotal, TaxAmt, Freight, TotalDue
	from purchasing_PurchaseOrderHeader2013
)

SELECT * FROM vw_2011_to_2013;

-- --------------------

-- where

SELECT *
FROM vw_2011_to_2013
WHERE subtotal >= 1000 AND shipmethodid = 2;

SELECT *
FROM vw_2011_to_2013
WHERE subtotal BETWEEN 1000 AND 10000;

SELECT DISTINCT shipmethodid
FROM vw_2011_to_2013;

SELECT *
FROM vw_2011_to_2013
WHERE shipmethodid = 5 OR shipmethodid = 4;

SELECT *
FROM vw_2011_to_2013
WHERE shipmethodid IN (5, 4, 1);

SELECT *
FROM vw_2011_to_2013
WHERE shipmethodid not IN (5, 4, 1);

SELECT *
FROM production_product
WHERE NAME LIKE '%Lock%';

SELECT *
FROM production_product
WHERE NAME LIKE '%Lock';