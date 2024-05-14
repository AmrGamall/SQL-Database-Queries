/*=========================== Part 01 (StoredProcedure) ===========================*/
--Part 01
--1.	Create a stored procedure to show the number of students per department.[use ITI DB] 
Create Procedure ShowNumOfStudentsPerDepartment
as
	Select D.Dept_Name, count(S.St_Id) [Number Of Students]
	from Department D, Student S
	where D.Dept_Id = S.Dept_Id
	group by D.Dept_Name

--Run
ShowNumOfStudentsPerDepartment
--2.	Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one. [MyCompany DB] 
create Proc CheckNumberOfEmployees
as
	declare @x int
	Select @x = count(ESSN)
	from Works_for
	where PNo = 100
	if(@x > 3)
		Select 'The number of employees in the project number 100 is 3 or more'
	else
		Select ' The following employees work for the project number 100 : '
		Select FName + ' '+ LName [Full Name]
		from Employee E, Works_for W
		where E.SSN = W.ESSN and W.PNo = 100
--Run
CheckNumberOfEmployees

--3.	Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]
create Proc UpdateNewEmployee @oldEmp int, @newEmp int, @PNum int
as
	update Works_for
		set ESSN = @newEmp
		where ESSN = @oldEmp and Pno = @PNum

execute UpdateNewEmployee 1111, 2222, 2 

--4.	Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 		Budget_New 
--100			Dbo 		2008-01-31		95000 			200000 

--This table will be used to audit the update trials on the Budget column (Project table, SD32-Company DB)
--Example:
--If a user updated the budget column then the project number, username that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column
Create table AuditUpdateOnBudget
(
 ProjectNo int,
 UserName  varchar(50),
 ModifiedDate  date,
 Budget_Old  int,
 Budget_New int
)

Create trigger hr.UpdateBudget
on hr.Project
after Update
as
	if Update(Budget)
	begin
		declare @PNum int, @oldBudget int, @newBudget int
		select @oldBudget = Budget from deleted
		Select @newBudget = Budget from inserted
		Select @PNum = ProjectNo from inserted
		insert into AuditUpdateOnBudget
		values(@PNum, suser_name(),  getdate(), @oldBudget, @newBudget)
	end

update HR.Project
	set Budget = 222
	where ProjectNo = 1

select * from AuditUpdateOnBudget

/*========================================================================================================*/
--Part 02
--1.	Create a stored procedure that calculates the sum of a given range of numbers
CREATE PROCEDURE CalculateSum
    @StartNumber INT,
    @EndNumber INT,
    @Sum INT OUTPUT
AS
BEGIN
    SET @Sum = 0;
    
    WHILE @StartNumber <= @EndNumber
    BEGIN
        SET @Sum = @Sum + @StartNumber;
        SET @StartNumber = @StartNumber + 1;
    END;
END;

DECLARE @Result INT;
EXEC CalculateSum @StartNumber = 1, @EndNumber = 10, @Sum = @Result OUTPUT;
SELECT @Result;

--2.	Create a stored procedure that calculates the area of a circle given its radius
CREATE PROCEDURE CalculateCircleArea
    @Radius FLOAT,
    @Area FLOAT OUTPUT
AS
BEGIN
    SET @Area = PI() * POWER(@Radius, 2);
END;
DECLARE @Result FLOAT;
EXEC CalculateCircleArea @Radius = 5, @Area = @Result OUTPUT;
SELECT @Result;

--3.	Create a stored procedure that calculates the age category based on a person's age ( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
CREATE PROCEDURE CalculateAgeCategory
    @Age INT,
    @Category NVARCHAR(20) OUTPUT
AS
BEGIN
    IF @Age < 18
        SET @Category = 'Child';
    ELSE IF @Age >= 18 AND @Age < 60
        SET @Category = 'Adult';
    ELSE
        SET @Category = 'Senior';
END;
DECLARE @Category NVARCHAR(20);
EXEC CalculateAgeCategory @Age = 45, @Category = @Category OUTPUT;
SELECT @Category;

--4.	Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
CREATE PROCEDURE CalculateStatistics
    @Numbers VARCHAR(MAX),
    @MaxValue INT OUTPUT,
    @MinValue INT OUTPUT,
    @Average FLOAT OUTPUT
AS
BEGIN
    CREATE TABLE #TempNumbers (Value INT);
    
    INSERT INTO #TempNumbers (Value)
    SELECT Value
    FROM STRING_SPLIT(@Numbers, ',');
    
    SELECT @MaxValue = MAX(Value), @MinValue = MIN(Value), @Average = AVG(Value)
    FROM #TempNumbers;
    
    DROP TABLE #TempNumbers;
END;


DECLARE @MaxValue INT;
DECLARE @MinValue INT;
DECLARE @Average FLOAT;
EXEC CalculateStatistics @Numbers = '5, 10, 15, 20, 25', @MaxValue = @MaxValue OUTPUT, @MinValue = @MinValue OUTPUT, @Average = @Average OUTPUT

/*========================================================================================================*/
--Part 03

--Create a database “by Wizard” named “RouteCompany”
--1.	Create the following tables with all the required information and load the required data as specified in each table using insert statements[at least two rows]
use RouteCompany

--Table Name				Details										Comments

--Department		--DeptNo (PK)	DeptName	Location      --	1-Create it programmatically	--[By Code]						
					--d1			Research		NY
					--d2			Accounting		DS
					--d3			Marketing		KW
															
create table Department
(
DeptNo int Primary Key,
DeptName varchar(50),
Location varchar(20)
)

insert into Department
values (1 , 'Research' , 'NY'),
       (2 ,'Accounting','DS'),
	   (3 , 'Marketing','KW')


--Employee	--EmpNo (PK)	Emp Fname	Emp Lname	DeptNo		Salary
			--25348			Mathew		Smith		d3			2500
			--10102			Ann			Jones		d3			3000
			--18316			John		Barrymore	d1			2400
			--29346			James		James		d2			2800
			--9031			Lisa		Bertoni		d2			4000
			--2581			Elisa		Hansel		d2			3600
			--28559			Sybl		Moser		d1			2900
--1-Create it programmatically
--2-PK constraint on EmpNo
--3-FK constraint on DeptNo
--4-Unique constraint on Salary
--5-EmpFname, EmpLname don’t accept null values 
create table Employee
(
EmpNo int Primary Key,
EmpFname varchar(40) not null,
EmpLname varchar(40) not null,
DeptNo int foreign key references Department(DeptNo) ,
Salary int unique
)

insert into Employee
values (25348 , 'Mathew' , 'Smith' , 3 , 2500),
       (10102 , 'Ann' , 'Jones' , 3 , 3500),
	   (18316 , 'John' , 'Barrimore' , 1 , 2400),
       (29346 , 'James' , 'James' , 2 , 2800),
	   (9031 , 'Lisa' , 'Bertoni' , 2 , 4000),
	   (2581 , 'Elisa' , 'Hansel' , 2 , 3600),
	   (28559 , 'Sybl' , 'Moser' , 1 , 2900)

--Project	--ProjectNo (PK)	ProjectName		Budget
			--p1				Apollo			120000
			--p2				Gemini			95000
			--p3				Mercury			185600
--1-Create it by Wizard
--2-ProjectName can't contain null values
--3-Budget allow null

insert into Project
values ( 1 , 'Apollo' , 120000),
       ( 2 , 'Gemini' , 95000),
       ( 3 , 'Mercury' , 185600)

--Works_on	--EmpNo (PK)	ProjectNo(PK)	Job			Enter_Date
			--10102				p1			Analyst		2006.10.1
			--10102				p3			Manager		2012.1.1
			--25348				p2			Clerk		2007.2.15
			--18316				p2			NULL		2007.6.1
			--29346				p2			NULL		2006.12.15
			--2581				p3			Analyst		2007.10.15
			--9031				p1			Manager		2007.4.15
			--28559				p1			NULL		2007.8.1
			--28559				p2			Clerk		2012.2.1
			--9031				p3			Clerk		2006.11.15
			--29346				p1			Clerk		2007.1.4

--1-Create it Wizard
--2- EmpNo INTEGER NOT NULL
--3-ProjectNo doesn't accept null values
--4-Job can accept null
--5-Enter_Date can’t accept null
--and has the current system date as a default value[visually]
--6-The primary key will be EmpNo,ProjectNo) 
--7-there is a relation between works_on and employee, Project  tables

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

---------------------------------------------------------------------------------------------

--Testing Referential Integrity	
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
--4-Delete the employee with id 10102

delete from Employee 
where EmpNo = 10102

-- The statement has been terminated.
--The DELETE statement conflicted with the REFERENCE constraint "FK_Works_on_Employee". 
-- The conflict occurred in database "RouteCompany", table "dbo.Works_on", column 'EmpNo'.

---------------------------------------------------------------------------------------------

--Table Modification

--1-Add  TelephoneNumber column to the employee table[programmatically]
alter table Employee
add TelephoneNumber varchar(40)

--2-drop this column[programmatically]
alter table Employee
drop column TelephoneNumber

--3-Build A diagram to show Relations between tables
----------------------------------------------------------------------------------------------
--2.	Create the following schema and transfer the following tables to it 
	--a.	Company Schema 
		--i.	Department table 
		--ii.	Project table 
create schema Company 

alter schema Company transfer Department
alter schema Company transfer Project

	--b.	Human Resource Schema
		--i.	  Employee table 
create schema HR

alter schema HR transfer Employee

--3.	Increase the budget of the project where the manager number is 10102 by 10%.
update Company.project
set Budget += Budget * 0.1
from HR.Employee Emp , Company.Project Pro , Works_on Wo
where Emp.EmpNo = Wo.EmpNo 
and Pro.ProjectNo = Wo.ProjectNo 
and Wo.Job = 'manager' 
and  Emp.EmpNo = 10102


Update Company.Project
set Budget += 0.1 * Budget
from HR.Employee E , Works_On W  ,Company.Project p
where p.ProjectNo = W.ProjectNo 
and E.EmpNo = W.Empno 
and E.EmpNo = 10102 
and W.Job = 'manager'

--4.	Change the name of the department for which the employee named James works.The new department name is Sales.
update	Company.Department
set DeptName = 'Sales'
from Company.Department Dep , HR.Employee Emp
where Dep.DeptNo = Emp.DeptNo and Emp.EmpFname = 'James'

--5.	Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
update Works_on 
set Enter_Date = '12.12.2007'
from HR.Employee Emp , Company.Department Dep , Works_on Wo , Company.project Pro
where Emp.EmpNo = Wo.EmpNo  
and Dep.DeptNo = Emp.DeptNo 
and Wo.ProjectNo =1 
and dep.DeptName = 'Sales'

--6.	Delete the information in the works_on table for all employees who work for the department located in KW.
delete from Works_on
where EmpNo in (select EmpNo from HR.Employee E, Department D where D.DeptNo = E.DeptNo and D.Location = 'KW') 

------------------------------------------------------------------------------------------------------------------------

/*========================================================================================================*/
--Part 04
--Use ITI DB
use ITI
--1.	Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table )
create Trigger PreventInsertInDepartment
on Department
instead of insert
as
	select 'You can’t insert a new record in that table'
		
insert into Department(Dept_Id, Dept_Name, Dept_Desc)
values(2, 'aaa', 'll')

--2.	Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 

--Server User Name   --	Date 	Note
		
Create table StudentAudit
(
 ServerUserName  varchar(100),
 Date  date,
 Note varchar(200)
)

--3.	Create a trigger on student table after insert to add Row in StudentAudit table 
		--•	 The Name of User Has Inserted the New Student  
		--•	Date
		--•	Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name]

create trigger AfterInsertInStudent
on Student
after insert
as
	declare @Note nvarchar(200), @St_Id int
	Select @St_Id = St_Id from inserted 
	select @Note = concat( suser_name() , '  Insert New Row with Key ', @St_Id ,'  in table Student')
	
	insert into StudentAudit
	values(suser_name(),  getdate(), @Note)

insert into Student (St_Id) values(2022)
select * from StudentAudit

--4.	Create a trigger on student table instead of delete to add Row in StudentAudit table 
		--○	 The Name of User Has Inserted the New Student
		--○	Date
		--○	Note that will be like “try to delete Row with id = [Student Id]” 

create trigger DeleteStudent
on Student
instead of delete
as
	declare @Note varchar(100), @St_Id int
	Select @St_Id = St_Id from deleted 
	
	insert into StudentAudit
	values(suser_name(),  getdate(), CONCAT (' try to delete Row with id  = ' , @St_Id))

delete from Student where St_Id = 1

select * from StudentAudit

------------------------------------------------------------------------------------------------------------------------

--Use MyCompany DB:
use MyCompany
--5.	Create a trigger that prevents the insertion Process for Employee table in March.

alter trigger PreventInsertInEmployee
on Employee
instead of insert
as
	begin
		if format(getdate(),'MMMM') = 'March'

			Select 'You can’t insert a new record in that table in March Month'
		else
		 insert into Employee
	     select * from inserted
	end
insert into Employee (SSN , Lname ) values (1,'ALi') 
------------------------------------------------------------------------------------------------------------------------
--Use SD32-Company:
use [SD32-Company]
--6.	Create an Audit table with the following structure 

--ProjectNo		UserName 	ModifiedDate 	Budget_Old 		Budget_New 
--p2			Dbo			2008-01-31			95000		200000

--This table will be used to audit the update trials on the Budget column (Project table, Company DB)
--If a user updated the budget column then the project number, username that made that update,  the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--(Note: This process will take place only if the user updated the budget column)

Create table AuditUpdateOnBudget
(
 ProjectNo int,
 UserName  varchar(50),
 ModifiedDate  date,
 Budget_Old  int,
 Budget_New int
)

Create trigger hr.UpdateBudget
on hr.Project
after Update
as
	if Update(Budget)
	begin
		declare @PNum int, @oldBudget int, @newBudget int
		select @oldBudget = Budget from deleted
		Select @newBudget = Budget from inserted
		Select @PNum = ProjectNo from inserted
		insert into AuditUpdateOnBudget
		values(@PNum, suser_name(),  getdate(), @oldBudget, @newBudget)
	end

update HR.Project
	set Budget = 222
	where ProjectNo = 1

select * from AuditUpdateOnBudget


----------------------------------------------------------------------------------------------------

--Part 05

--Use ITI DB :
use ITI
--•	Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?
use iti 

create clustered index myindex
on Department(Manager_hiredate)

--•	Create an index that allows you to enter unique ages in the student table. What will happen?
create unique nonclustered index myIndex02
on student(st_age)

--- can't create unique index because  there is duplicate key in the colunm (St_Age)

--•	Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB then allow him to select and insert data into tables and deny Delete and update

----------------------------------------------------------------------------------------------------
