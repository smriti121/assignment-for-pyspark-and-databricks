use AdventureWorks2022;

select * from HumanResources.Employee;

select * from HumanResources.Employee where MaritalStatus = 'M';

---find the employee who are working under marketing
select * from HumanResources.Employee where JobTitle LIKE '%Marketing%';

---find the employee who are working under Network Manager
select * from HumanResources.Employee where JobTitle LIKE 'Network Manager';

select count(*) from HumanResources.Employee;

select count(*) from 
HumanResources.Employee
where Gender = 'M'; 

select count(*) from 
HumanResources.Employee
where Gender = 'F'; 

select count(MaritalStatus) from 
HumanResources.Employee
where Gender = 'F'; 

---Find the employee having SalariedFlag as 1
select * from HumanResources.Employee where SalariedFlag = 1;

---Find the employee having VacationHours more than 70
select * from HumanResources.Employee where VacationHours > 70;

---VacationHour more than 70 but less than 90
select * from HumanResources.Employee where VacationHours> 70 and VacationHours<90;

---Find all jobs having title as Designer
select * from HumanResources.Employee where JobTitle LIKE '%Designer%';

---Find the total employee worked as Technician
select count(*) from HumanResources.Employee where Jobtitle LIKE '%Technician%';

---display the data having NationalIDNumber, JobvTitle,MaritalStatus, gender for all under marketting job titile 
select NationalIDNumber, JobTitle, MaritalStatus, Gender from HumanResources.Employee where JobTitle LIKE '%Marketing%';

---Find max vacation hours
select Max(VacationHours) from HumanResources.Employee;

---Find min sick leaves
select Min(SickLeaveHours) from HumanResources.Employee;

select * from HumanResources.Department where Name = 'Production';
select * from HumanResources.Department where Name = '7';

select * from HumanResources.Employee where BusinessEntityID in (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory where DepartmentID = 7);


select * from HumanResources.Department where GroupName = 'Reseach and Development';

select * from HumanResources.Employee where BusinessEntityID in(select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where DepartmentID in 
(select DepartmentID from HumanResources.Department where GroupName = 'Research and Development'))

---find all emplolyees who work in day shift
select * from HumanResources.Shift

select * from HumanResources.Shift
where Name ='Day'

select * from HumanResources.EmployeeDepartmentHistory;

select * from HumanResources.EmployeeDepartmentHistory
where ShiftID = 1;

select * from HumanResources.EmployeeDepartmentHistory
where ShiftID = (select ShiftID from HumanResources.Shift
where Name ='Day');

select * from HumanResources.Employee where BusinessEntityID in(select BusinessEntityID from HumanResources.EmployeeDepartmentHistory 
where ShiftID = (select ShiftID from HumanResources.Shift
where Name ='Day'));

---find all employees where pay frequency is 1  --pay
select * from HumanResources.EmployeeDepartmentHistory where ShiftID =1;

---find candidate who are not placed  

select * from HumanResources.JobCandidate where BusinessEntityID in (select BusinessEntityID from HumanResources.Employee);

---find the address of employee
select * from Person.Address ;
select AddressLine1, City, PostalCode from Person.Address where AddressID = (select AddressID from Person.BusinessEntityAddress where BusinessEntityID = 101);

---find the name for employee working in group and development
select FirstName, LastName from Person.Person where BusinessEntityID in (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory where DepartmentID in (select DepartmentID from HumanResources.Department where GroupName='Research and Development'));









