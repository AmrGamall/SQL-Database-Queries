
--Assignment 05 sql:
---------------------

--Part 01 (Views)
Use ITI41

--1. Create a view that displays the student's full name, course name if the student has a grade more than 50. 

create view displayFulName41
as
select CONCAT(s.St_Fname,' ',s.St_Lname) [full name] , c.Crs_Name, sc.Grade
from Student s, Course c , Stud_Course sc
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade > 50

select * from displayFulName41
---------------------------------------------------------------------------------------------------------------------------
--2. Create an Encrypted view that displays manager names and the topics they teach. 
create or alter view managerandTopics41
with encryption
as 
select i.Ins_Name, t.Top_Name
from Instructor i, Course c, Ins_Course ic, Topic t
where i.Ins_Id = ic.Ins_Id and c.Crs_Id = ic.Crs_Id and t.Top_Id = c.Top_Id

select * from managerandTopics41
---------------------------------------------------------------------------------------------------------------------------
--3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and 
--describe what is the meaning of Schema Binding
create view InstructorSdJava41
with encryption , schemabinding
as 
select i.Ins_Name, d.Dept_Name
from dbo.Instructor i, dbo.Department d
where d.Dept_Id = i.Dept_Id and d.Dept_Name in ('SD', 'Java')
select * from InstructorSdJava41
---------------------------------------------------------------------------------------------------------------------------
--4. Create a view “V1” that displays student data for students who live in Alex or Cairo. 
--Note: Prevent the users to run the following query 
create view v141 with encryption
as
select *
from Student s 
where s.St_Address in ('Alex', 'Cairo')
with check option

Update v141 set st_address='tanta'
Where st_address='alex'

---------------------------------------------------------------------------------------------------------------------------
use MyCompany
--5. Create a view that will display the project name and the number of employees working on it.
create view ProjectwithEmployees
as 
select p.Pname, COUNT(w.ESSn) [number of employees]
from Project p , Works_for w
where p.Pnumber = w.Pno 
group by p.Pname

select * from ProjectwithEmployees
---------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------

use SD32-Company

--1. Create a view named “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'.
create view v_clerk41
as 
select w.empno, w.projectno, w.enter_date
from Works_on w
where job = 'clerk'
 select * from v_clerk41
---------------------------------------------------------------------------------------------------------------------------
--2. Create view named “v_without_budget” that will display all the projects data without budget
create view v_without_budget41
as 
select projectNo, projectName
from hr.project
select * from v_without_budget41

---------------------------------------------------------------------------------------------------------------------------
--3. Create view named “v_count “ that will display the project name and the Number of jobs in it
create view v_count41
as
select p.projectname, COUNT(w.job) [number of jobs]
from hr.project p, works_on w 
where p.projectno= w.projectno
group by p.projectname

select * from v_count41
---------------------------------------------------------------------------------------------------------------------------
--4. Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view “v_clerk”)
create view v_project_p241
as 
select v.empno [employee number]
from v_clerk41 v
where v.projectno = 2

select * from v_project_p241
---------------------------------------------------------------------------------------------------------------------------
--5. modify the view named “v_without_budget” to display all DATA in project p1 and p2.
alter view v_without_budget41
as
select *
from hr.project p 
where p.projectno in (1,2)

select * from v_without_budget41
---------------------------------------------------------------------------------------------------------------------------
--6. Delete the views “v_ clerk” and “v_count”
drop view v_clerk41,v_count41
---------------------------------------------------------------------------------------------------------------------------
--7. Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
create view employeedepartment2
as
select empno, emplname
from hr.employee
where deptno=2
select * from employeedepartment2
---------------------------------------------------------------------------------------------------------------------------
--8. Display the employee lastname that contains letter “J” (Use the previous view created in Q#7)
select emplname
from employeedepartment2
where emplname like '%j%'
---------------------------------------------------------------------------------------------------------------------------
--9. Create view named “v_dept” that will display the department# and department name
create view v_dept41
as
select d.deptno, d.deptname
from department d
select * from v_dept41
---------------------------------------------------------------------------------------------------------------------------
--10. using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
insert into v_dept41 
values (7, 'CS')

---------------------------------------------------------------------------------------------------------------------------
--11. Create view name “v_2006_check” that will display employee Number, the project Number where he works and 
--the date of joining the project which must be from the first of January and the last of December 2006.this view will be 
--used to insert data so make sure that the coming new data must match the condition
create or alter view v_2006_check41
as 
select empno, projectno, enter_date
from works_on 
where enter_date between '2007-01-1' and '2007-12-31'
with check option 


--Run
select * from v_2006_check41
insert into v_2006_check41 values(22222, 2, '2007-2-1') -- successful insertion
insert into v_2006_check41 values(22222, 1, '2006-2-1') -- failed because Date Range
-----------------------------------------------------

-- Part 02 --
-- Use ITI DB 
-- 1- Create a stored procedure to show the number of students per department.[use ITI DB]

create proc shownumbersperdepartment
as
select d.Dept_Name, COUNT(s.St_Id) [number of students]
from Student s, Department d
where d.Dept_Id= s.Dept_Id
group by d.Dept_Name
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Use MyCompany DB

-- 2 -Create a stored procedure that will check for the Number of employees in the project p1 
--    if they are more than 3 print message to the user (The number of employees in the project p1 is 3 or more) 
--    if they are less display a message to the user (The following employees work for the project p1)
--    in addition to the first name and last name of each one. [MyCompany DB] 
create proc checkNumberofEmployees
as
declare @x int
select @x = count(Essn)
from Works_for
where Pno = 1

if(@x > 3)
	select 'The number of employees in the project p1 is 3 or more'
else
	select 'The following employees work for the project p1'
	select e.fname+' '+e.Lname [full name]
	from Employee e, Works_for w
	where e.SSN = w.ESSn and w.Pno = 1


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3- Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
-- The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]
create proc newEmployee41 @oldEmp int, @newEmp int, @pno int 
as 
	update Works_for
	set ESSn = @newEmp
	where ESSn = @oldEmp and Pno = @pno

execute newEmployee41 25348,22222,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Part 03

--1.	Create a stored procedure that calculates the sum of a given range of numbers
create proc calculateSum41 @start int, @end int, @sum int output
as
begin
set @sum = 0
while @start  <= @end
begin
set @sum = @sum + @start
set @start += 1
end
end

declare @result int 
execute calculateSum41 @start = 1, @end=10, @sum = @result output
select @result
--2.	Create a stored procedure that calculates the area of a circle given its radius
create proc calcArea41 @radius float, @area float output
as
	set @area = pi() * POWER(@radius,2) 

declare @result float 
exec calcArea41 @radius= 5,@area = @result output
select @result
--3.	Create a stored procedure that calculates the age category based on a person's age ( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
create proc ageCategory41 @age int, @category varchar(30) output
as
	if @age < 18
		set @category = 'child'
	else if @age >=18 and @age <60
		set @category = 'Adult'
	else 
		set @category = 'senior'
declare @result varchar(30)
exec ageCategory41 @age=25, @category = @result output
select @result
--4.	Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
create proc calcStatistics @numbers varchar(max), @max int output, @min int output,  @avg float output
as
create table tempNumbers (value int)

insert into tempNumbers (value)
select value
from string_split (@numbers, ',')

select @max = MAX(value), @min = min(value), @avg = AVG(value)
from tempNumbers

drop table tempNumbers

declare @maxV int , @minV int , @average float
exec calcStatistics @numbers = '5, 10, 15, 20, 25', @max = @maxV output,  @min = @minV output,  @avg = @average output
select @maxV , @minV, @average
----------------------------------------
----------------------------------------
-- Part 04 -- 
-- Create a database “by Wizard” named “RouteCompany”

-- 1- Create the following tables with all the required information 
use RouteCompany41

-- Department Table [Create it programmatically]
-- DeptNo (PK)
-- DeptName
-- Location

create table Department
(
DeptNo int Primary Key,
DeptName varchar(50),
Location varchar(20)
)
-- Employee Table [Create it programmatically]
--EmpNo(PK)
--Emp Fname
--Emp Lname
--DeptNo
--Salary

create table Employee
(
EmpNo int Primary Key,
EmpFname varchar(40) not null,
EmpLname varchar(40) not null,
DeptNo int foreign key references Department(DeptNo) ,
Salary int unique
)

-- Project Table (Create it by wizard)
-- ProjectNo (PK)
-- ProjectName (Can't be null)
-- Budget (Allow null)


-- Works_on Table (Create it by wizard)

--EmpNo (PK , INTEGER , NOT NULL)
--ProjectNo(PK , doesn't accept null values)
--Job (can accept null)
--Enter_Date (can’t accept null , has the current system date as a default value )
-- The primary key will be EmpNo,ProjectNo
-- there is a relation between works_on and employee, Project  tables
-- load the required data as specified in each table  using insert statements[at least two rows]

-- Department Table Data --
-------------------------------------------
--DeptNo(PK)   DeptName   Location
------------------------------------------- 
--  d1         Research       NY
--  d2        Accounting      DS
--  d3        Marketing       KW
-------------------------------------------
-------------------------------------------

insert into Department
values (1 , 'Research' , 'NY'),
       (2 ,'Accounting','DS'),
	   (3 , 'Marketing','KW')

-- Employee Table Data --
-----------------------------------------------------
--EmpNo (PK)    Emp-Fname   Emp-Lname  DeptNo  Salary
-----------------------------------------------------
--  25348        Mathew      Smith       d3     2500
--  10102         Ann        Jones       d3     3000
--  18316         John      Barrimore    d1     2400
--  29346        James       James       d2     2800
--  9031         Lisa       Bertoni      d2     4000
--  2581         Elisa       Hansel      d2     3600
-- 28559         Sybl        Moser       d1     2900
-----------------------------------------------------
-----------------------------------------------------

insert into Employee
values (25348 , 'Mathew' , 'Smith' , 3 , 2500),
       (10102 , 'Ann' , 'Jones' , 3 , 3500),
	   (18316 , 'John' , 'Barrimore' , 1 , 2400),
       (29346 , 'James' , 'James' , 2 , 2800),
	   (9031 , 'Lisa' , 'Bertoni' , 2 , 4000),
	   (2581 , 'Elisa' , 'Hansel' , 2 , 3600),
	   (28559 , 'Sybl' , 'Moser' , 1 , 2900)




-- Project Table Data --
-----------------------------------------------
--ProjectNo(PK)   ProjectName    Budget
-----------------------------------------------
--   p1             Apollo        120000
--   p2             Gemini        95000
--   p3             Mercury       185600
-----------------------------------------------
-----------------------------------------------

insert into Project
values ( 1 , 'Apollo' , 120000),
       ( 2 , 'Gemini' , 95000),
       ( 3 , 'Mercury' , 185600)

-- Works_on Table Data --
---------------------------------------------------
--EmpNo(PK)   ProjectNo(PK)    Job      Enter_Date
---------------------------------------------------
-- 10102          p1         Analyst    2006.10.1
-- 10102          p3         Manager    2012.1.1
-- 25348          p2          Clerk     2007.2.15
-- 18316          p2           NULL     2007.6.1
-- 29346          p2           NULL     2006.12.15
-- 2581           p3         Analyst    2007.10.15
-- 9031           p1         Manager    2007.4.15
-- 28559          p1           NULL     2007.8.1
-- 28559          p2          Clerk     2012.2.1
-- 9031           p3          Clerk     2006.11.15
-- 29346          p1          Clerk     2007.1.4


---------------------------------------------------
---------------------------------------------------
insert into Works_on
values (10102 , 1 , 'Analyst' ,'2006.10.1'),
       (10102 , 3 , 'Manager' ,'2012.1.1'),
	   (25348 , 2 , 'Clerk' ,'2007.2.15'),
       (18316 ,2,NULL,'2007.6.1'),
       (29346,2,NULL,'2006.12.15'),
       (2581,3,'Analyst','2007.10.15'),
       (9031,1,'Manager','2007.4.15'),
       (28559,1,NULL,'2007.8.1'),
       (28559,2, 'Clerk','2012.2.1'),
       (9031,3,'Clerk','2006.11.15'),
       (29346,1,'Clerk','2007.1.4')

--Testing Referential Integrity
--------------------------------
--1-Add new employee with EmpNo =11111 In the works_on table [what will happen]

insert into works_on (EmpNo)
values (11111)

-- The statement has been terminated (INSERT fails) 
-- Cannot insert the value NULL into column 'ProjectNo'column does not allow nulls

---------------------------------------------------------------------------------------------
--2-Change the employee number 10102  to 11111  in the works on table [what will happen]

update Works_on
set EmpNo = 11111
where EmpNo = 10102

-- because there is no employee with number 11111 
-- The UPDATE statement conflicted with the FOREIGN KEY constraint "FK_Works_on_Employee".
-- The conflict occurred in database "RouteCompany", table "HR.Employee", column 'EmpNo'.

---------------------------------------------------------------------------------------------
--3-Modify the employee number 10102 in the employee table to 22222. [what will happen]

update Employee
set EmpNo = 22222
where EmpNo = 10102

-- The statement has been terminated.
-- The UPDATE statement conflicted with the REFERENCE constraint "FK_Works_on_Employee". 
-- The conflict occurred in database "RouteCompany", table "dbo.Works_on", column 'EmpNo'.

---------------------------------------------------------------------------------------------
--4-Delete the employee with number 10102

delete from Employee 
where EmpNo = 10102

-- The statement has been terminated.
--The DELETE statement conflicted with the REFERENCE constraint "FK_Works_on_Employee". 
-- The conflict occurred in database "RouteCompany", table "dbo.Works_on", column 'EmpNo'.

---------------------------------------------------------------------------------------------
--== Table modification ==-- 
--------------------------
--1-Add  TelephoneNumber column to the employee table[programmatically]
alter table Employee
add TelephoneNumber varchar(15)


---------------------------------------------------------------------------------------------
--2-drop this column[programmatically]
alter table Employee
drop column TelephoneNumber

---------------------------------------------------------------------------------------------
--3-Bulid A diagram to show Relations between tables
----------------------------------------------------------------------------------------------

-- 2-Create the following schema and transfer the following tables to it
-------------------------------------------------------------------------
--  1- Company Schema:
--     Department table 
--     Project table 
create schema Company
alter schema Company transfer Department
alter schema Company transfer Project


----------------------------------------------------------
--  2- Human Resource Schema
--     Employee table 
create schema HR
alter schema HR transfer Employee

-----------------------------------------------------------------------------------------------------------------------
-- 3-Increase the budget of the project where the manager number is 10102 by 10%.
update Company.Project
set Budget += Budget *0.1
from HR.Employee e, Company.Project p, works_on w
where e.Empno = w.empNo and p.ProjectNo = W.ProjectNo and w.job = 'manager' and e.Empno = 10102

--------------------------------------------------------------------------------------------------------------------------
-- 4- Change the name of the department for which the employee named James works.
--	  The new department name is Sales.

update Company.Department
set deptName = 'Sales'
from Company.Department d, HR.Employee e
where d.deptNo = e.DeptNo and e.empFName = 'James'
-------------------------------------------------------------------------------------------------------------------------

-- 5.Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. 
--	The new date is 12.12.2007.
update works_on 
set Enter_Date = '12.12.2007'
from HR.Employee e, Company.Project p, works_on w,Company.Department d
where e.Empno = w.empNo and W.ProjectNo = 1 and  d.deptNo = e.DeptNo and deptName = 'Sales'


-------------------------------------------------------------------------------------------------------------------------

-- 6. Delete the information in the works_on table for all employees who work for the department located in KW.
delete from works_on
where EmpNo in (select EmpNo 
				from Company.Department d, HR.Employee e
				where d.deptNo = e.DeptNo and d.location = 'KW')
------------------------------------------------------------------------------------------------------------------------

