use AdventureWorks2022;

---Q1.Find the average currency rate conversion from USD to Algerian Dinar and Australian Dollar Use USD - DZD ,USD-AUD
select * From Sales.CountryRegionCurrency
select * From Sales.Currency
select * From Sales.CurrencyRate

select CONCAT_WS(' To ',FromCurrencyCode,ToCurrencyCode) Currency_Conversion,avg(AverageRate)
from Sales.CurrencyRate where FromCurrencyCode='USD' and ToCurrencyCode in('DZD','AUD')
group by FromCurrencyCode,ToCurrencyCode

---Q2.Find the products having offer on it and display product name ,safety Stock Level, Listprice, and product model id, type of discount, percentage of discount, offer start date and offer end date


select * from Sales.SpecialOfferProduct
select * from Production.Product
select * From Sales.SpecialOffer

select
(select p.ProductModelID from Production.Product p where p.ProductID=sop.ProductID)as Product_ModelID,
(select p.Name from Production.Product p where p.ProductID=sop.ProductID)as Product_Name,
(select p.SafetyStockLevel from Production.Product p where p.ProductID=sop.ProductID)as Safety_Stock_Level,
(select p.ListPrice from Production.Product p where p.ProductID=sop.ProductID)as List_Price,
(select sp.DiscountPct from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Percentage_of_discount,
(select sp.Type from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Type_of_discount,
(select concat_ws('  and  ',sp.StartDate,sp.EndDate) from sales.SpecialOffer sp where sp.SpecialOfferID=sop.SpecialOfferID)as Start_and_end_date
from sales.SpecialOfferProduct sop

---Q3.create view to display Product name and Product review
select * from Production.Product
select *from Production.ProductReview

--create view ProductReviews as
select p.Name,r.Comments
from Production.Product p
join Production.ProductReview r on p.ProductID = r.ProductID;

---Q4.find out the vendor for product paint, Adjustable Race and blade
Select * from Purchasing.ProductVendor
Select *from Purchasing.Vendor
Select * from Production.Product

select pv.BusinessEntityID,
	(select v.Name 
	from Purchasing.Vendor v 
	where v.BusinessEntityID=pv.BusinessEntityID) 
	VendorName,
	(select p.Name
	from Production.Product p 
	where pv.ProductID=p.ProductID) 
	ProductName
from Purchasing.ProductVendor pv
where pv.ProductID in 
(select p.ProductID 
from  Production.Product p 
where p.Name like '%paint%' or 
	  p.Name like '%Blade%' or 
	  p.Name ='Adjustable Race')

---Q5.find product details shipped through ZY - EXPRESS
select * from Purchasing.ShipMethod
select * from Production.Product
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader

select
(select p.Name from Production.Product p where p.ProductID=pd.ProductID)as ProductName,
(select p.ProductNumber from Production.Product p where p.ProductID=pd.ProductID)as ProductNumber,
(select sm.ShipMethodID from Purchasing.ShipMethod sm where sm.ShipMethodID=ph.ShipMethodID)as ShipID,
(select sm.Name from Purchasing.ShipMethod sm where sm.ShipMethodID=ph.ShipMethodID)as ShipName
from Purchasing.PurchaseOrderDetail pd
join Purchasing.PurchaseOrderHeader ph 
    on pd.PurchaseOrderID = ph.PurchaseOrderID
where ph.ShipMethodID = (
    select s.ShipMethodID 
    from Purchasing.ShipMethod s 
    where s.Name LIKE 'ZY - EXPRESS'
)

---Q6.find the tax amt for products where order date and ship date are on the same day
select * from Production.Product
select * from Purchasing.PurchaseOrderHeader
select * from Purchasing.PurchaseOrderDetail

select 
(select p.Name from Production.Product p where p.ProductID=pd.ProductID)as ProductName,
ph.TaxAmt as Tax_Amount
from Purchasing.PurchaseOrderDetail pd
join Purchasing.PurchaseOrderHeader ph 
on pd.PurchaseOrderID = ph.PurchaseOrderID
where day(ph.OrderDate)=day(ph.ShipDate)

---Q7. find the average days required to ship the product based on shipment type.
select* from Purchasing.ShipMethod
select* from Production.Product
select* from Purchasing.PurchaseOrderHeader
select* from Purchasing.PurchaseOrderDetail

select 
    ps.Name as Shipment_Type, 
    avg(DATEDIFF(DAY, ph.OrderDate, ph.ShipDate)) as Avg_Shipping_Days
from Purchasing.PurchaseOrderHeader ph
join Purchasing.ShipMethod ps 
    on ph.ShipMethodID = ps.ShipMethodID
where ph.ShipDate is not null
group by ps.Name
order by Avg_Shipping_Days desc;

---Q8.find the name of employees working in day shift
select * from HumanResources.EmployeeDepartmentHistory

select CONCAT_WS(' ',FirstName,LastName)as Emp_name from Person.Person
where BusinessEntityID in (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where ShiftID in (select ShiftID from HumanResources.Shift where Name='DAY'))

---Q9. based on product and product cost history find the name , service provider time and average Standardcost
Select * from Production.Product
select * from Production.ProductCostHistory

select 
p.Name as Product_Name,
DATEDIFF_BIG(DAY,min(StartDate),max(EndDate)) as service_provider_time,
AVG(ph.StandardCost)as Average_Standard_Cost
from Production.ProductCostHistory ph
join Production.Product p on
ph.ProductID=p.ProductID
group by p.Name


---Q10. find products with average cost more than 500
Select * from Production.Product
select * from Production.ProductCostHistory

select P.Name,avg(pc.StandardCost)Avg_stand_cost 
from Production.ProductCostHistory pc
join Production.Product p on
pc.ProductID=p.ProductID
group by p.Name 
having avg(pc.StandardCost)>500


--11.find the employee who worked in multiple territory
select * from Person.Person
Select * from HumanResources.Employee
select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
select
    p.BusinessEntityID,
    CONCAT_WS(' ', p.FirstName, p.LastName) as Emp_name,
    count(distinct sth.TerritoryID) as TerritoryCount
from HumanResources.Employee e
join Person.Person p on p.BusinessEntityID = e.BusinessEntityID
join Sales.SalesTerritoryHistory sth on e.BusinessEntityID = sth.BusinessEntityID
group by p.BusinessEntityID, p.FirstName, p.LastName
having count(distinct sth.TerritoryID) > 1
order by TerritoryCount desc;

---Q12. Find out the product model name, product description for culture as Arabic
select * from Production.ProductModel
select * from Production.Culture
select * from Production.ProductDescription

select pm.Name as Product_Model_Name,
pd.Description as Product_Description
from Production.ProductModel pm
join Production.ProductModelProductDescriptionCulture pdc
on pm.ProductModelID=pdc.ProductModelID
join Production.ProductDescription pd
on pd.ProductDescriptionID=pd.ProductDescriptionID
join Production.Culture pc
on pc.CultureID=pdc.CultureID
where pc.Name like 'Arabic'
group by pm.Name,pd.Description

--Q13. display EMP name, territory name, saleslastyear salesquota and bonus

select territoryId,
(Select CONCAT(FirstName,' ',LastName) from Person.Person pp where pp.BusinessEntityID=sp.BusinessEntityID)as EmployeeName,
(Select Name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)as TerritoryName,
(Select [Group] from Sales.SalesTerritory sl where sl.TerritoryID=sp.TerritoryID)as GroupName,
SalesLastYear,
SalesQuota,
Bonus 
from sales.SalesPerson sp

--Q14. display employee name, territory name, sales last year, sales quota and bonus from germany and united kingdom
select TerritoryID,
(Select CONCAT(FirstName,' ',LastName) from Person.Person pp where pp.BusinessEntityID=sp.BusinessEntityID)as EmployeeName,
(Select Name from sales.SalesTerritory st where st.TerritoryID=sp.TerritoryID)as TerritoryName,
(Select [Group] from Sales.SalesTerritory sl where sl.TerritoryID=sp.TerritoryID)as GroupName,
SalesLastYear,
SalesQuota,
Bonus
from sales.SalesPerson sp
where sp.TerritoryID IN (
    select TerritoryID 
    from Sales.SalesTerritory 
    where Name IN ('United Kingdom', 'Germany'))

--Q15.Find all employees who worked in all North America territory

select  distinct TerritoryId,
(select distinct concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme
from Sales.SalesTerritoryHistory sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE [Group] IN ('North America'))

--Q16.find all products in the cart
Select (select Name from Production.Product pp where pp.ProductID=si.ProductID)Prod_name,
(select ProductNumber from Production.Product pp1 where pp1.ProductID=si.ProductID)Prod_Number,
Quantity
from Sales.ShoppingCartItem si

--Q17.find all the products with special offer
select * from Sales.SpecialOffer
select * from Sales.SpecialOfferProduct

Select Distinct(Name) from Production.Product pp where pp.ProductID 
in(select ProductID from Sales.SpecialOfferProduct)

--Q18.find all employees name , job title, card details whose credit card expired in the month 11 and year as 2008

select(select CONCAT_WS(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=pc.BusinessEntityID)EmpName,
(select JobTitle from HumanResources.Employee  e where e.BusinessEntityID=pc.BusinessEntityID)Job_Description,
(select CONCAT_WS(' : ',ExpMonth,ExpYear )from Sales.CreditCard cc where cc.CreditCardID=pc.CreditCardID)Card_detail

from Sales.PersonCreditCard pc where pc.CreditCardID in(select CreditCardID from Sales.CreditCard cc where cc.ExpMonth=11 and cc.ExpYear=2008)

--Q19.Find the employee whose payment might be revised (Hint : Employee payment history)
select * From Person.Person
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory

SELECT e.BusinessEntityID, p.FirstName, p.LastName, COUNT(eph.RateChangeDate) AS PayRevisions
FROM HumanResources.EmployeePayHistory eph
JOIN HumanResources.Employee e 
ON eph.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p 
ON e.BusinessEntityID = p.BusinessEntityID

--with subQuery
select 
    (select p.FirstName from Person.Person p where p.BusinessEntityID = e.BusinessEntityID) as FirstName,
    (select p.LastName from Person.Person p where p.BusinessEntityID = e.BusinessEntityID) as LastName,
    e.BusinessEntityID,
    (select COUNT(RateChangeDate) 
     from HumanResources.EmployeePayHistory eph 
     where eph.BusinessEntityID = e.BusinessEntityID) as PayRevisions
from HumanResources.Employee e
where (select COUNT(RateChangeDate) 
       from HumanResources.EmployeePayHistory eph 
       where eph.BusinessEntityID = e.BusinessEntityID) > 1

--Q20.Find the personal details with address and address type
--(hint: Business Entiry Address , Address, Address type) 

select * from Person.BusinessEntityAddress
Select * from Person.Address
select * from Person.AddressType
select* from Person.Person

select
CONCAT_WS(' ',p.FirstName,p.LastName)as Employee_Name,
a.AddressLine1  Address,
at.Name  Address_Type
from person.person p
join Person.BusinessEntityAddress ba
on p.BusinessEntityID=ba.BusinessEntityID
join Person.Address a
on a.AddressID=ba.AddressID
join Person.AddressType at
on at.AddressTypeID=ba.AddressTypeID

--Q21.	Find the name of employees working in group of North America territory ### 
select TerritoryID,
(select concat(' ',FirstName,LastName)from Person.Person p where p.BusinessEntityID=sp.BusinessEntityID)Emp_Name,
(select name  from Sales.SalesTerritory st where  st.TerritoryID=sp.TerritoryID) TerritoryName,
(select [Group] from Sales.SalesTerritory st1 where st1.TerritoryID=sp.TerritoryID)Group_NAme,SalesLastYear,SalesQuota
from Sales.SalesPerson sp WHERE sp.TerritoryID IN (
    SELECT TerritoryID 
    FROM Sales.SalesTerritory 
    WHERE [Group] IN ('North America'))

--Q22. Find the employee whose payment is revised for more than once 

select e.BusinessEntityID, p.FirstName, p.LastName, count(eph.RateChangeDate) AS PayRevisions
from HumanResources.EmployeePayHistory eph
join HumanResources.Employee e 
on eph.BusinessEntityID = e.BusinessEntityID
join Person.Person p 
on e.BusinessEntityID = p.BusinessEntityID
group by e.BusinessEntityID, p.FirstName, p.LastName
having count(eph.RateChangeDate) > 1;

--Q23.display the personal details of  employee whose payment is revised for more than once.
select * from Person.Address
select * from Person.Person
Select * from HumanResources.Employee

select p.BusinessEntityID, p.FirstName, p.LastName, p.EmailPromotion, e.Gender, e.JobTitle, 
       eph.PayFrequency, count(eph.RateChangeDate) as PayRevisions
from HumanResources.EmployeePayHistory eph
join HumanResources.Employee e on eph.BusinessEntityID = e.BusinessEntityID
join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
group by p.BusinessEntityID, p.FirstName, p.LastName, p.EmailPromotion, e.Gender, e.JobTitle, eph.PayFrequency
having count(eph.RateChangeDate) > 1;

--24.	find the duration of payment revision on every interval 
--(inline view) Output must be as given format 
--## revised time – count of revised salries 
--## duration – last duration of revision 
--e.g there are two revision date 01-01-2022 and revised in 01-01-2024   so duration here is 2years 

select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory

 select p.FirstName, p.LastName, SalaryRevisions.RevisedTime, 
       DATEDIFF(YEAR, SalaryRevisions.FirstRevisionDate, SalaryRevisions.LastRevisionDate) AS Duration
from (
    select eph.BusinessEntityID, 
           count(eph.RateChangeDate)  RevisedTime, 
           min(eph.RateChangeDate)  FirstRevisionDate, 
           max(eph.RateChangeDate)  LastRevisionDate
    from HumanResources.EmployeePayHistory eph
    group by eph.BusinessEntityID
) as SalaryRevisions
join Person.Person p on p.BusinessEntityID = SalaryRevisions.BusinessEntityID
order RevisedTime desc



--25.check if any employee from jobcandidate table is having any payment revisions 
select * from HumanResources.JobCandidate
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory


select * from HumanResources.JobCandidate j where j.BusinessEntityID
in(select BusinessEntityID from HumanResources.Employee e where e.BusinessEntityID in 
(select eph.BusinessEntityID from HumanResources.EmployeePayHistory eph group by eph.BusinessEntityID
having COUNT(eph.RateChangeDate)>0))

---26.check the department having more salary revision 
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.EmployeePayHistory

select d.Name as DepartmentName, count(eph.RateChangeDate) as TotalSalaryRevisions
from HumanResources.EmployeePayHistory eph
join HumanResources.EmployeeDepartmentHistory edh 
    on eph.BusinessEntityID = edh.BusinessEntityID
join HumanResources.Department d 
    on edh.DepartmentID = d.DepartmentID
group by d.Name
order by TotalSalaryRevisions desc;

--27.check the employee whose payment is not yet revised 
select p.FirstName from Person.Person p where p.BusinessEntityID =
(select e.BusinessEntityID from HumanResources.Employee e where e.BusinessEntityID
not in (
select distinct eph.BusinessEntityID from HumanResources.EmployeePayHistory eph)
)--output is zero rows(query for verification purpose)

select e.BusinessEntityID, concat_ws(' ',p.FirstName, p.LastName)as EmployeeName
from HumanResources.Employee e
join Person.Person p 
on e.BusinessEntityID = p.BusinessEntityID
where e.BusinessEntityID not in 
(select distinct BusinessEntityID from HumanResources.EmployeePayHistory);

--28.find the job title having more revised payments 

select distinct(e.JobTitle), count(eph.RateChangeDate)  TotalSalaryRevisions
from HumanResources.EmployeePayHistory eph
join HumanResources.Employee e 
    on eph.BusinessEntityID = e.BusinessEntityID
group by e.JobTitle
having count(eph.RateChangeDate)>1
order by TotalSalaryRevisions desc;

-------------------------------Inline View---------------------------------------------
SELECT JobTitle, TotalSalaryRevisions
FROM (
    SELECT e.JobTitle, COUNT(eph.RateChangeDate) AS TotalSalaryRevisions
    FROM HumanResources.EmployeePayHistory eph
    JOIN HumanResources.Employee e 
        ON eph.BusinessEntityID = e.BusinessEntityID
    GROUP BY e.JobTitle
) AS SalaryRevisions
WHERE TotalSalaryRevisions > 1
ORDER BY TotalSalaryRevisions DESC


--29.find the employee whose payment is revised in shortest duration (inline view) 
select BusinessEntityID, FirstName, LastName, min(datediff(day,StartDate, EndDate)) 
as ShortestRevisionDuration
from (
    select e.BusinessEntityID, p.FirstName, p.LastName, eph.StartDate, eph.EndDate
    from HumanResources.EmployeeDepartmentHistory eph
    join HumanResources.Employee e on eph.BusinessEntityID = e.BusinessEntityID
    join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
) as PaymentRevisions
group by  BusinessEntityID, FirstName, LastName;

--30.find the colour wise count of the product (tbl: product)
select Color, count(ProductID) ProductCount
from Production.Product
where Color is not null
group by Color
order  by ProductCount desc;

--31.find out the product who are not in position to sell (hint: check the sell start and end date)
select * from Production.Product

select distinct ProductID, Name, SellStartDate, SellEndDate
from Production.Product where (SellEndDate is not null and SellEndDate < GETDATE()) 
 or SellStartDate is null

--32.find the class wise, style wise average standard cost  

select class Class,style Style,avg(StandardCost)Avg_Cost from Production.Product where
class is not null and Style is not null
group by Class,Style 
order by Avg_Cost 


--33.check colour wise standard cost 
 select * from Production.Product

 select color Color,avg(StandardCost)Color_AvgCost from Production.Product
 where color is not null 
 group by Color
 order by Color_AvgCost

 --34.find the product line wise standard cost 
 select Productline Product_line,avg(StandardCost)P_Std from Production.Product
 where ProductLine is not null
 group by ProductLine
 order by P_Std

 --35.Find the state wise tax rate (hint: Sales.SalesTaxRate, Person.StateProvince) 

select sp.Name as StateName, sp.StateProvinceCode, str.TaxRate
from Sales.SalesTaxRate str
join Person.StateProvince sp 
    on str.StateProvinceID = sp.StateProvinceID
order by sp.Name  

--Q36. Find the department wise count of employees 
select* from HumanResources.Employee
select*from HumanResources.Department
select*from HumanResources.EmployeeDepartmentHistory

select d.Name as DepartmentName,count(e.BusinessEntityID) as EmployeeCount
from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory edh
on e.BusinessEntityID=edh.BusinessEntityID
join HumanResources.Department d
on d.DepartmentID=edh.DepartmentID
group by d.Name

--Q37.Find the department which is having more employees 

select d.DepartmentID, d.Name as DepartmentName, count(e.BusinessEntityID) as EmployeeCount
from HumanResources.Employee e
JOIN HumanResources.Department d on e.BusinessEntityID = d.DepartmentID
group by d.DepartmentID, d.Name
order by EmployeeCount desc

--Q38.Find the job title having more employees 
Select * from HumanResources.Employee
select*from HumanResources.Department

select count(BusinessEntityID)as EmployeeCount,JobTitle from  HumanResources.Employee
group by JobTitle
order by EmployeeCount desc

--Q39.Check if there is mass hiring of employees on single day 
Select * from HumanResources.Employee

select  Hiredate, count(BusinessEntityID)Employee_count  From HumanResources.Employee
group by HireDate
having count(BusinessEntityID)>1
Order by Employee_count desc

--Q40.Which product is purchased more? (purchase order details) 
select * from Purchasing.PurchaseOrderDetail
select * from Production.Product


select p.ProductID, p.Name as Product_Name, sum(pd.OrderQty) as TotalQuantityPurchased
from Purchasing.PurchaseOrderDetail pd
JOIN Production.Product p on p.ProductID = pd.ProductID
group by p.ProductID, p.Name
order by TotalQuantityPurchased desc

--41.Find the territory wise customers count   (hint: customer) 

select * from Sales.Customer
SELECT TerritoryID, COUNT(CustomerID) AS CustomerCount
FROM Sales.Customer
GROUP BY TerritoryID
ORDER BY CustomerCount DESC;

--42.Which territory is having more customers (hint: customer) 

SELECT  TerritoryID, COUNT(CustomerID) AS CustomerCount
FROM Sales.Customer
GROUP BY TerritoryID
ORDER BY CustomerCount DESC

--Q43.Which territory is having more stores (hint: customer) 
 
 SELECT  TerritoryID, COUNT(StoreID) AS Store_Count
FROM Sales.Customer
GROUP BY TerritoryID
ORDER BY Store_Count DESC

--Q44. Is there any person having more than one credit card (hint: PersonCreditCard) 
select * from Person.Person
select * from Sales.PersonCreditCard 

select CONCAT_WS(' ',p.FirstName,p.LastName)as PersonName,COUNT(pc.CreditCardID)as CreditCardCount
from Person.Person p
join sales.PersonCreditCard pc
on p.BusinessEntityID=pc.BusinessEntityID
group by p.FirstName,p.LastName
having count(pc.CreditCardID)>1

--Q45.Find the product wise sale price (sales order details)		
select * from Production.Product
select * from sales.SalesOrderDetail

select p.ProductID, p.Name as ProductName, 
       SUM(sod.OrderQty * sod.UnitPrice) as TotalSalesPrice
from Sales.SalesOrderDetail sod
JOIN Production.Product p on sod.ProductID = p.ProductID
group by p.ProductID, p.Name
order by TotalSalesPrice desc


--Q46.Find the total values for line total product having maximum order 
select ProductID, sum(LineTotal) as TotalValue
from Sales.SalesOrderDetail
group by ProductID
having sum(OrderQty) = (
    select max(TotalOrders)
    from(
        select ProductID, sum(OrderQty) as TotalOrders
        from Sales.SalesOrderDetail
        group by ProductID
    ) as SubQuery
);




--Q48.Calculate the age of employees 
select* from HumanResources.Employee

select BusinessEntityID, BirthDate, 
       DATEDIFF(YEAR, BirthDate, GETDATE()) - 
       case 
           when (MONTH(BirthDate) > MONTH(GETDATE())) 
                OR (MONTH(BirthDate) = MONTH(GETDATE()) AND DAY(BirthDate) > DAY(GETDATE())) 
           then 1 else 0 
       end as Age
from HumanResources.Employee;
-------other way
select concat_ws(' ',p.FirstName,p.LastName)as EmployeeName,
year(getdate())-year(e.BirthDate)as Age
from HumanResources.Employee e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID


--Q49.Calculate the year of experience of the employee based on hire date



select concat_ws(' ',p.FirstName,p.LastName)as EmployeeName,
year(getdate())-year(e.HireDate)Experience
from HumanResources.Employee e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID

--Q50.Find the age of employee at the time of joining 

select  e.BusinessEntityID,concat_ws(' ',p.FirstName,p.LastName)as EmployeeName,
year(e.HireDate)-year(e.BirthDate)Age_at_joining
from HumanResources.Employee e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID

select BusinessEntityID,BirthDate, HireDate, 
    DATEDIFF(YEAR, BirthDate, HireDate) as AgeAtJoining
from HumanResources.Employee

--Q51.Find the average age of male and female
select * from HumanResources.Employee

select Gender,Avg(datediff(YEAR,birthdate,GETDATE()))Avg_Age from HumanResources.Employee
group by Gender

 --Q52.Which product is the oldest product as on the date (refer  the product sell start date) 
 select * from Production.Product

select top 1 name,
 max(year(getdate())-year(SellStartDate))as productage
 from Production.Product
 group by Name