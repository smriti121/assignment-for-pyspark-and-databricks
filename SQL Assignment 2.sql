use AdventureWorks2022;

--Q53.	Find the product wise sale price (sales order details)
SELECT p.ProductID, p.Name AS ProductName, 
       SUM(sod.OrderQty * sod.UnitPrice) AS TotalSalesPrice
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p ON sod.ProductID = p.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalSalesPrice DESC

--Q54.	Find the total values for line total product having maximum order
 select * from Purchasing.PurchaseOrderDetail

 select Top 1 PurchaseOrderID,
 sum(LineTotal)as TotalLines,
 max(OrderQty)as Max_Order
 from Purchasing.PurchaseOrderDetail
 group by PurchaseOrderID
 having max(OrderQty)>1



 --Q55.Calculate the age of employees

 select concat_ws(' ',p.FirstName,p.LastName)as EmployeeName,
year(getdate())-year(e.BirthDate)as Age
from HumanResources.Employee e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID

--Q56.Calculate the year of experience of the employee based on hire date
select concat_ws(' ',p.FirstName,p.LastName)as EmployeeName,
year(getdate())-year(e.HireDate)Experience
from HumanResources.Employee e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID

--Q57. Find the age of employee at the time of joining
SELECT BusinessEntityID,BirthDate, HireDate, 
    DATEDIFF(YEAR, BirthDate, HireDate) AS AgeAtJoining
FROM HumanResources.Employee

--Q58.Find the average age of male and female

select Gender,Avg(datediff(YEAR,birthdate,GETDATE()))Avg_Age from HumanResources.Employee
group by Gender

--Q59.Which product is the oldest product as on the date (refer  the product sell start date)
select top 1 name,
 max(year(getdate())-year(SellStartDate))as productage
 from Production.Product
 group by Name

--Q60.Display the product name, standard cost, and time duration for the same cost. (Product cost history)
  select * from Production.ProductCostHistory

  select p.Name,
         ph.StandardCost,
	     DATEDIFF(YEAR,ph.EndDate,ph.StartDate)Time_duration,
         avg(ph.Standardcost)over(partition by DATEDIFF(YEAR,ph.EndDate,ph.StartDate))Avg_StandardCost
  from Production.ProductCostHistory ph
  join Production.Product p
  on p.ProductID=ph.ProductID
  where ph.EndDate is not null and
  ph.StartDate is not null

  --Q61. Find the purchase id where shipment is done 1 month later of order date  
  Select * from Purchasing.ShipMethod
  select * from Purchasing.PurchaseOrderHeader

 select PurchaseOrderID
        
 from Purchasing.PurchaseOrderHeader where datediff(MONTH,OrderDate,ShipDate)=1 

 --Q62Find the sum of total due where shipment is done 1 month later of order date ( purchase order header)

 select sum(TotalDue)Total
 from Purchasing.PurchaseOrderHeader where datediff(MONTH,OrderDate,ShipDate)=1 


 --Q63.Find the average difference in due date and ship date based on  online order flag
 SELECT OnlineOrderFlag, 
       AVG(DATEDIFF(DAY, ShipDate, DueDate)) AS Avg_Days_Difference
FROM Sales.SalesOrderHeader
GROUP BY OnlineOrderFlag

--Q64. Display business entity id, marital status, gender, vacationhr, average vacation based on marital status

select * from HumanResources.Employee
select * from HumanResources.Department
select BusinessEntityId,
        MaritalStatus,
		Gender,
		VacationHours,
	    avg(vacationhours)over(partition by maritalstatus)Vac_Mari_Status
from HumanResources.Employee

--65Display business entity id, marital status, gender, vacationhr, average vacation based on gender

select BusinessEntityId,
        MaritalStatus,
		Gender,
		VacationHours,
	    avg(vacationhours)over(partition by gender)Avg_Based_Gender
from HumanResources.Employee
 
 --66.Display business entity id, marital status, gender, vacationhr, average vacation based on organizational level

 select  BusinessEntityId,
        MaritalStatus,
		Gender,
		VacationHours,
	    avg(vacationhours)over(partition by Organizationlevel )Vac__Org_level
from HumanResources.Employee

--67Display entity id, hire date, department name and department wise count of employee and count based on organizational level in each dept


SELECT  
    e.BusinessEntityID, 
    e.HireDate, 
    d.Name AS DepartmentName, 
    COUNT(e.BusinessEntityID) OVER (PARTITION BY d.Name) AS DepartmentEmployeeCount,
    COUNT(e.BusinessEntityID) OVER (PARTITION BY d.Name, ed.OrganizationLevel) AS OrgLevelEmployeeCount,
    COALESCE(ed.OrganizationLevel, 0) AS OrganizationLevel -- Handling NULL values
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory ed 
    ON e.BusinessEntityID = ed.BusinessEntityID
JOIN HumanResources.Department d 
    ON ed.DepartmentID = d.DepartmentID;


--68.Display department name, average sick leave and sick leave per department
select distinct
	   d.Name DepartmentName,
	   avg (SickLeaveHours) over(Partition by d.departmentID)Depart_Wise_Sickleave,
	   count(SickLeaveHours) over(Partition by d.departmentid)Org_lev_Sickleave
	   from HumanResources.Employee e join HumanResources.EmployeeDepartmentHistory eh
	   on e.BusinessEntityID=eh.BusinessEntityID
	   join HumanResources.Department d on 
	   d.DepartmentID=eh.DepartmentID


--69.Display the employee details first name, last name,  with total count 
--of various shift done by the person and shifts count per department

Select * from Person.Person
select * from HumanResources.Shift
select * from HumanResources.Employee
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory

select p.FirstName,
       p.LastName,
	   Count(s.ShiftID)TotalShift,
	   count(*)over(partition by d.departmentid)Dept_Shift_count
from Person.Person p
join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory ed
on ed.BusinessEntityID=e.BusinessEntityID
join HumanResources.Department d
on d.DepartmentID=ed.DepartmentID
join HumanResources.Shift s
on s.ShiftID=ed.ShiftID
group by e.BusinessEntityID,p.FirstName,p.LastName,d.DepartmentID,d.Name

--70.Display country region code, group average sales quota based on territory id
select * from Sales.SalesPerson
select * from Sales.SalesTerritory

select st.CountryRegionCode,
       st.[Group],
	   avg(sp.SalesQuota) as Avg_SalesQuota
from Sales.SalesTerritory st
join Sales.SalesPerson sp
on sp.TerritoryID=st.TerritoryID
where SalesQuota is not null
group by st.CountryRegionCode,st.[Group]
order by st.CountryRegionCode,Avg_SalesQuota Desc




--Q71.	Display special offer description, category and avg(discount pct) per the category


Select * from Sales.SpecialOfferProduct
Select * from Sales.SpecialOffer

select distinct description,
        Category,
		avg(DiscountPct)over(partition by  category)Avg_By_Dispt_Cat
from Sales.SpecialOffer so
join Sales.SpecialOfferProduct
sp
on sp.SpecialOfferID=so.SpecialOfferID

--Q72.	Display special offer description, category and avg(discount pct) per the month

SELECT distinct
    Description, 
    Category, 
    Month(StartDate) AS OfferMonth,
    AVG(DiscountPct) OVER (PARTITION BY Month(StartDate)) AS Avg_Discount_By_Year
FROM Sales.SpecialOffer so
JOIN Sales.SpecialOfferProduct sp 
    ON sp.SpecialOfferID = so.SpecialOfferID;

--Q73.	Display special offer description, category and avg(discount pct) per the year
SELECT distinct
    Description, 
    Category, 
    YEAR(StartDate) AS OfferYear,
	
    AVG(so.DiscountPct) OVER (PARTITION BY YEAR(so.StartDate),Year(so.Enddate)) AS Avg_Discount_By_Year
FROM Sales.SpecialOffer so
JOIN Sales.SpecialOfferProduct sp 
    ON sp.SpecialOfferID = so.SpecialOfferID;


--Q74.	Display special offer description, category and avg(discount pct) per the type
select distinct description,
        Category,
		avg(DiscountPct)over(partition by  type)Avg_By_Dispt_Type
from Sales.SpecialOffer so
join Sales.SpecialOfferProduct
sp
on sp.SpecialOfferID=so.SpecialOfferID



--Q75.	Using rank and dense rank find territory wise top sales person
 select * from Sales.SalesTerritory
 select * from HumanResources.Employee

SELECT 
    sp.BusinessEntityID,
    st.TerritoryID,
    st.Name AS TerritoryName,
    sp.SalesYTD,
    RANK() OVER (PARTITION BY st.TerritoryID ORDER BY sp.SalesYTD DESC) AS Rank_YTD,
    DENSE_RANK() OVER (PARTITION BY st.TerritoryID ORDER BY sp.SalesYTD DESC) AS Dense_Rank_YTD
FROM Sales.SalesPerson sp
JOIN HumanResources.Employee e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
WHERE sp.SalesYTD IS NOT NULL
ORDER BY st.TerritoryID, Rank_YTD;
