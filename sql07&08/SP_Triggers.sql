/*=========================== Part 01 (StoredProcedure) ===========================*/
--Part 01
--1.	Create a stored procedure to show the number of students per department.[use ITI DB] 
use ITI
Create Procedure ShowNumOfStudentsPerDepartment
as
  select d.Dept_Name,COUNT(s.St_Id)
  from Student s , Department d
  where s.Dept_Id = d.Dept_Id
  group by d.Dept_Name
	
--Run
ShowNumOfStudentsPerDepartment

use MyCompany
--2.	Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one. [MyCompany DB] 
create or alter Proc CheckNumberOfEmployees
as
declare @count int
select @count=COUNT(ESSn)
from Works_for 
where Pno = 100

if (@count >3)
	select 'The number of employees in the project 100 is 3 or more'
else
	select 'The following employees work for the project 100'
	select Fname + ' ' + Lname [Full name]
	from Employee e , Works_for w
	where e.SSN = w.ESSn and w.Pno = 100
	
--Run
CheckNumberOfEmployees

--3.	Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]
create Proc UpdateNewEmployee @oldEmp int, @newEmp int, @PNum int
as
 update Works_for
 set ESSn = @newEmp
 where ESSn = @oldEmp and Pno =@PNum

	

--Run
execute UpdateNewEmployee 112233, 102672, 100 

--4.	Create an Audit table with the following structure 
--ProjectNo 	UserName 	ModifiedDate 	Budget_Old 		Budget_New 
--100			Dbo 		2008-01-31		95000 			200000 

--This table will be used to audit the update trials on the Budget column (Project table, SD32-Company DB)
--Example:
--If a user updated the budget column then the project number, username that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
--Note: This process will take place only if the user updated the budget column
--Use SD32-Company:
use [SD32-Company]

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
 
 if update (Budget)
 begin
   declare @Pnum int , @OldBudget int , @NewBudget int
   select @OldBudget = Budget from deleted
   select @NewBudget =  Budget from inserted
   select @Pnum = ProjectNo from inserted

   insert into AuditUpdateOnBudget
   values (@Pnum , SUSER_NAME(), getDate(),@OldBudget,@NewBudget)
 end

	



-- Test		
update HR.Project
	set Budget = 225
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
   set @Sum = 0

   while @StartNumber <= @EndNumber
   begin
     set @Sum = @Sum + @StartNumber
	 set @StartNumber = @StartNumber + 1
   end


END;

-- Run
DECLARE @Result INT;
EXEC CalculateSum @StartNumber = 1, @EndNumber = 10, @Sum = @Result OUTPUT;
SELECT @Result;

--2.	Create a stored procedure that calculates the area of a circle given its radius
CREATE PROCEDURE CalculateCircleArea
    @Radius FLOAT,
    @Area FLOAT OUTPUT
AS
BEGIN
    set @Area = PI()*Power(@Radius,2)
END;

-- Run
DECLARE @Result FLOAT;
EXEC CalculateCircleArea @Radius = 5, @Area = @Result OUTPUT;
SELECT @Result;

--3.	Create a stored procedure that calculates the age category based on a person's age ( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 then Category is Adult otherwise  Category is Senior)
CREATE PROCEDURE CalculateAgeCategory
    @Age INT,
    @Category NVARCHAR(20) OUTPUT
AS
BEGIN
    if @Age < 18
		set @Category = 'Child'
	else if @Age >=18 and @age < 60

		set @Category = 'Adult'
	else

		set @Category = 'Senior'
END;

-- Runn
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
   Create table TempNumbers (value int)
   insert into TempNumbers (value)
   select value
   from String_Split(@Numbers,',')

   select @MaxValue = max(Value) ,@MinValue = min(value) ,@Average = avg(value)
   from TempNumbers

   Drop table TempNumbers


END;


--Run
DECLARE @MaxValue INT;
DECLARE @MinValue INT;
DECLARE @Average FLOAT;
EXEC CalculateStatistics @Numbers = '5, 10, 15, 20, 25', @MaxValue = @MaxValue OUTPUT, @MinValue = @MinValue OUTPUT, @Average = @Average OUTPUT
select @MaxValue As MaxValue , @MinValue as MinValue ,@Average As Average
/*========================================================================================================*/
--Part 04
--Use ITI DB
use ITI
--1.	Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table )
create Trigger PreventInsertInDepartment
on Department
instead of insert
as
	select 'You can not insert a new record at that table'

--Test		
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
  declare @Note varchar(200) , @St_Id int
  select @St_Id = St_Id from inserted
  select @Note = CONCAT(SUSER_NAME(),' nsert New Row with Key = ' , @St_Id , ' in table  student' )

  insert into StudentAudit
  values(SUSER_NAME(),GETDATE(),@Note)
	

--Test
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
 declare @Note varchar(200) , @St_Id int
  select @St_Id = St_Id from deleted
  select @Note = CONCAT(' try to delete Row with id = ' , @St_Id )

  insert into StudentAudit
  values(SUSER_NAME(),GETDATE(),@Note)

	
-- Test
delete from Student where St_Id = 1

select * from StudentAudit

------------------------------------------------------------------------------------------------------------------------

--Use MyCompany DB:
use MyCompany
--5.	Create a trigger that prevents the insertion Process for Employee table in March.

Create or alter trigger PreventInsertInEmployee
on Employee
instead of insert
as
	begin
		 if FORMAT(GETDATE() , 'MMMM') = 'March'
		    select 'You can not insert in the table'

		else
		 insert into Employee
		 select * from inserted
	end

--Test
insert into Employee (SSN , Lname ) values (1,'ALi') 

/*========================================================================================================*/