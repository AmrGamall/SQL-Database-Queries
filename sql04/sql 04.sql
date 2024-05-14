

--assignment 4 sql (6):
-------------------------

--part 01:
--------------
use ITI41
--1. Select max two salaries in the instructor table. 
select top(2)  salary
from instructor
order by Salary desc
---------------------------------------------------------------------------------------------------------------------------
--2. Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
select *
from ( select Dept_Id, Ins_Name, Salary, ROW_NUMBER() over (partition by Dept_Id order by salary desc) as rn
		from Instructor
		where Salary is not null) as newTable
where rn <=2  
--rn < 3 
--rn in (1,2) 
--rn = 1 or rn = 2

---------------------------------------------------------------------------------------------------------------------------
--3. Write a query to select a random student from each department. “using one of Ranking Functions)
select * 
from ( select s.St_Fname, s.Dept_Id, ROW_NUMBER() over(partition by Dept_Id order by newid()) as rn
		from Student s
		where Dept_Id is not null) as newTable
where rn = 1

---------------------------------------------------------------
--Part 02:
--------------------
use adventureworks2012

--1. Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred 
--within the period ‘7/28/2002’ and ‘7/29/2014’
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014'
---------------------------------------------------------------------------------------------------------------------------
--2. Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID, Name, StandardCost
from Production.Product
where StandardCost < 110
---------------------------------------------------------------------------------------------------------------------------
--3. Display ProductID, Name if its weight is unknown
select ProductID, Name, Weight
from Production.Product
where Weight is null
---------------------------------------------------------------------------------------------------------------------------
--4. Display all Products with a Silver, Black, or Red Color
 select *
 from Production.Product
 where Color in ('Silver', 'Black', 'Red')
---------------------------------------------------------------------------------------------------------------------------
--5. Display any Product with a Name starting with the letter B
 select *
 from Production.Product
 where Name like 'B%'
---------------------------------------------------------------------------------------------------------------------------
--6. Run the following Query
	UPDATE Production.ProductDescription
	SET Description = 'Chromoly steel_High of defects'
	WHERE ProductDescriptionID = 3

--7. Then write a query that displays any Product description with underscore value in its description.
 select Description
 from Production.ProductDescription
 where Description like '%[_]%'
---------------------------------------------------------------------------------------------------------------------------
--8. Display the Employees HireDate (note no repeated values are allowed)
 select distinct HireDate
 from HumanResources.Employee
---------------------------------------------------------------------------------------------------------------------------
--9. Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format 
--"The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
 select CONCAT('the '+Name+' is only! ', ListPrice) [list price]
 from Production.Product
 where ListPrice between 100 and 120
 order by ListPrice
-------
 
 select 'the '+Name+' is only! ' + CONVERT(varchar(20), ListPrice) [list price]
 from Production.Product
 where ListPrice between 100 and 120
 order by ListPrice
----------------------------------------------------------------
--Part 03 (Functions):
--------------------------
 --1. Create a scalar function that takes a date and returns the Month name of that date.
create function getmonthName41(@date date)
returns varchar(20) 
begin
return FORMAT(@date,'MMMM')
end
select dbo.getmonthName41(GETDATE())
---------------------------------------------------------------------------------------------------------------------------
--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
 create function getValuesbetweenIntegers41(@x int, @y int)
 returns @table table (valuesBetween int)
 as
 begin
 while(@x < @y-1)
 begin
 insert into @table values(@x+1)
 set @x+=1
 end
 return
 end

 select * from getValuesbetweenIntegers41(1, 10)
---------------------------------------------------------------------------------------------------------------------------
--3. Create a table-valued function that takes Student No and returns Department Name with Student full name.
 create function getDepartmentBySdNo41(@studentNo int)
 returns @table table (fullname varchar(40), deptName varchar(40))
 as
 begin
 insert into @table
 select concat(s.St_Fname,' ',s.St_Lname) [full name], d.Dept_Name
 from Student s, Department d
 where d.Dept_Id = s.St_Id and s.St_Id = @studentNo
 return
 end

 select * from getDepartmentBySdNo41(10)
---------------------------------------------------------------------------------------------------------------------------
--4. Create a scalar function that takes Student ID and returns a message to user 
	--a. If first name and Last name are null then display 'First name & last name are null'
	--b. If First name is null then display 'first name is null'
	--c. If Last name is null then display 'last name is null'
	--d. Else display 'First name & last name are not null'	

create function showMessage41(@studentid int)
returns varchar(50)
begin
declare @fname varchar(20)
declare @lname varchar(20)
declare @msg varchar(50)
select @fname = s.St_Fname, @lname = s.St_Lname
from Student s
where s.St_Id = @studentid
if(@fname is null and @lname is null)
	set @msg = 'First name & last name are null'
else if(@fname is null)
	set @msg = 'First name is null'
else if(@lname is null)
	set @msg = 'last name is null'
else 
	set @msg = 'First name & last name are not null'

return @msg

end

select dbo.showMessage41(10)

---------------------------------------------------------------------------------------------------------------------------
--5. Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, 
--Manager Name and hiring date with this format. 

create function formathiringDate41(@format int)
returns @table table (depatName varchar(30), managerName varchar(30), hiringDate varchar(30))
as
begin
insert into @table
select d.Dept_Name, i.Ins_Name, CONVERT(varchar, d.Manager_hiredate, @format)
from Instructor i , Department d
where d.Dept_Id= i.Dept_Id
return
end

 select * from formathiringDate41(112)
---------------------------------------------------------------------------------------------------------------------------
--6. Create multi-statement table-valued function that takes a string
	--a. If string='first name' returns student first name
	--b. If string='last name' returns student last name 
	--c. If string='full name' returns Full Name from student table
--Note: Use “ISNULL” function

 create function getStudentName41(@input varchar(30))
 returns @table table (studentName varchar(30))
 as
 begin
 if(@input = 'first name')
	insert into @table
	select ISNULL(s.St_Fname, 'not found')
	from Student s
else  if(@input = 'last name')
	insert into @table
	select ISNULL(s.St_Lname, 'not found')
	from Student s
else  if(@input = 'full name')
	insert into @table
	select concat(ISNULL(s.St_Fname, 'not found'), ' ',ISNULL(s.St_Lname, 'not found'))
	from Student s
 return
 end

 select * from getStudentName41('full name')
---------------------------------------------------------------------------------------------------------------------------
Use MyCompany
--7. Create function that takes project number and display all employees in this project 
create function getEmployeesByProjNo41(@projectno int)
returns @table table (employeeName varchar(50))
as
begin
insert into @table
select e.Fname+' '+e.Lname
from employee e, project p, Works_for w
where e.SSN = w.ESSn and p.Pnumber = w.Pno and p.Pnumber = @projectno
return
end

select * from getEmployeesByProjNo41(100)
 