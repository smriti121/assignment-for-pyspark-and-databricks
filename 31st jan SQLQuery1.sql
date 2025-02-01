use AdventureWorks2022;

select BusinessEntityId, NationalIdNumber, JobTitle,(select firstname from Person.Person p where p.BusinessEntityID = e.BusinessEntityID) FirstName from HumanResources.Employee e;

---add personal details of employee middle name, last names

select BusinessEntityID, NationalIDNumber, JobTitle,
(select concat(firstname, ' ', middlename, ' ', lastname) from person.person p where p.BusinessEntityID = e.BusinessEntityID)FullName
from HumanResources.Employee e;

select BusinessEntityID, NationalIDNumber, JobTitle,
(select concat_ws(' ',firstname, middlename, lastname) from person.person p where p.BusinessEntityID = e.BusinessEntityID)FullName
from HumanResources.Employee e;

---display national_id, first_name, last_name and department name, department group

select NationalIDNumber from HumanResources.Employee;
select * from  Person.Person;
select * from HumanResources.EmployeeDepartmentHistory;
select * from  HumanResources.Department;
select BusinessEntityID, DepartmentID, ed.* from  HumanResources.EmployeeDepartmentHistory ed;

select(select concat(firstname,lastname)
from Person.Person p 
where p.BusinessEntityID = ed.BusinessEntityID) Person_detail,
(select NationalIDNumber from HumanResources.Employee e 
where e.BusinessEntityID = ed.BusinessEntityID) EMP_detail,
(select concat(name, GroupName) from HumanResources.Department d
where d.DepartmentID = ed.DepartmentID)dept_details 
from  HumanResources.EmployeeDepartmentHistory ed;



---display first_name, last_name, department, ship time
select
    (select FirstName from Person.Person p where p.BusinessEntityID = ed.BusinessEntityID) AS FirstName,
    (select LastName from Person.Person p where p.BusinessEntityID = ed.BusinessEntityID) AS LastName,
    (select Name from HumanResources.Department d where d.DepartmentID = ed.DepartmentID) AS Department,
    ed.ShiftID AS ShipTime
from HumanResources.EmployeeDepartmentHistory ed;


---display product name and product review based on production schema
select 
    p.Name AS ProductName, 
    pr.ReviewerName AS ProductReview
from Production.Product p
JOIN Production.ProductReview pr
    ON p.ProductID = pr.ProductID;


--- find the employee's name, job title, credit card  expired in month 11 and year 2008
select * from Person.Person;
select * from HumanResources.Employee;
select * from Sales.SalesOrderHeader;
select * from Sales.CreditCard;

select  
    (select CONCAT(p.FirstName, ' ', p.LastName)  
     from Person.Person p  
     where p.BusinessEntityID = e.BusinessEntityID) AS EmployeeName,  

    (select JobTitle  
     from HumanResources.Employee  
     where BusinessEntityID = e.BusinessEntityID) AS JobTitle,  

    (select cc.CardNumber  
     from Sales.CreditCard cc  
     where cc.CreditCardID = soh.CreditCardID) AS CreditCardNumber  

from Sales.SalesOrderHeader soh, HumanResources.Employee e  
where soh.CreditCardID IN (  
    select CreditCardID  
    from Sales.CreditCard  
    where ExpMonth = 11 AND ExpYear = 2008  
)  
AND soh.SalesPersonID = e.BusinessEntityID;





--- display records from currency rate from USD to AUD
select * from Sales.CurrencyRate;
select *
from Sales.CurrencyRate
where FromCurrencyCode = 'USD' AND ToCurrencyCode = 'AUD';



---display EMP name, territory name, group, SaleslastYear Salequota, bonus from germany and united kingdom
select * from Sales.SalesTerritory;
select 
    (select CONCAT(firstName, ' ', lastName) 
     from Person.Person p 
     where p.BusinessEntityID = sp.BusinessEntityID) AS EmpName,
    
    (select Name 
     from Sales.SalesTerritory st 
     where st.TerritoryID = sp.TerritoryID) AS TerritoryName,
    
    (select [Group] 
     from Sales.SalesTerritory st 
     where st.TerritoryID = sp.TerritoryID) AS TerritoryGroup,

    sp.SalesLastYear,
    sp.SalesQuota,
    sp.Bonus
from Sales.SalesPerson sp
where sp.TerritoryID IN (
    select TerritoryID 
    from Sales.SalesTerritory 
    where Name IN ('Germany', 'United kingdom')
);


---find all employee who worked in all north America territory

select 
    (select CONCAT(firstName, ' ', lastName) 
     from Person.Person p 
     where p.BusinessEntityID = sp.BusinessEntityID) AS EmpName,
    
    (select Name 
     from Sales.SalesTerritory st 
     where st.TerritoryID = sp.TerritoryID) AS TerritoryName,
    
    (select [Group] 
     from Sales.SalesTerritory st 
     where st.TerritoryID = sp.TerritoryID) AS TerritoryGroup,

    sp.SalesLastYear,
    sp.SalesQuota,
    sp.Bonus
from Sales.SalesPerson sp
where sp.TerritoryID IN (
    select TerritoryID 
    from Sales.SalesTerritory 
    where [Group] = 'North America'
);


---find the product details in cart
select * from Production.Product;
select * from Sales.SalesOrderDetail;

select 
    (select p.Name 
     from Production.Product p 
     where p.ProductID = sod.ProductID) AS ProductName,
    
    sod.OrderQty AS Quantity,
    sod.LineTotal AS TotalPrice,
    
    (select p.StandardCost 
     from Production.Product p 
     where p.ProductID = sod.ProductID) AS ProductCost,
    
    (select p.ListPrice 
     from Production.Product p 
     where p.ProductID = sod.ProductID) AS ProductPrice
from Sales.SalesOrderDetail sod
where sod.SalesOrderID = SalesOrderID; 

---find the product with special offer
select * from Sales.SpecialOffer;
select * from Production.Product;

select 
    (select p.Name 
     from Production.Product p 
     where p.ProductID = sop.ProductID) AS ProductName,
    
    (select so.Description 
     from Sales.SpecialOffer so 
     where so.SpecialOfferID = sop.SpecialOfferID) AS SpecialOfferName,
    
    sop.SpecialOfferID,
    sop.ProductID
from Sales.SpecialOfferProduct sop
where sop.SpecialOfferID IN (
    select SpecialOfferID
    from Sales.SpecialOffer
    where StartDate <= GETDATE()  
      AND EndDate >= GETDATE()    
);

select Name from Production.Product pp
where pp.ProductID in(
select ProductID from Sales.SpecialOffer where Type ='No Discount');
