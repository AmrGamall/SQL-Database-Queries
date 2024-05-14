
--Assignment 06 sql:
-------------------------


--part 01
use ITI41
-- 1- Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
-- ( Display a message for user to tell him that he can’t insert a new record in that table )

create trigger preventInsertioninDepartment
on Department 
instead of insert
as	
		select 'you can’t insert a new record in that table'

		
insert into Department(Dept_Id, Dept_Name, Dept_Desc)
values(2, 'aaa', 'll')

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2- Create table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 
--Server User Name
--Date 
--Note
-- Create a trigger on student table after insert to add Row in StudentAudit table 
-- (The Name of User Has Inserted the New Student
--  Date
--- Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name])
-- [Use ITI DB]

Create table StudentAudit
(
 ServerUserName  varchar(100),
 Date  date,
 Note varchar(200)
)

create trigger afterinsertioninStudent
on student
after insert
as 
	declare @st_id int, @note varchar(200)
	select @st_id = St_id from inserted
	select @note = CONCAT(SUSER_NAME(),' Insert New Row with Key = ',@st_id, ' in table Student')

	insert into StudentAudit
	values(SUSER_NAME(), GETDATE(), @note)

insert into Student (St_Id) values(2022)
select * from StudentAudit
------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3- Create a trigger on student table instead of delete to 
--add Row in StudentAudit table table 
-- (The Name of User Has Inserted the New Student, Date, and note that will be like “try to delete Row with id = [Student Id]” ).
create trigger insteadofdeleteStudent
on student
instead of delete
as 
	declare @st_id int, @note varchar(200)
	select @st_id = St_id from deleted
	select @note = CONCAT(SUSER_NAME(),' try to delete Row with Key = ',@st_id, ' in table Student')

	insert into StudentAudit
	values(SUSER_NAME(), GETDATE(), @note)


delete from Student where St_Id = 1

select * from StudentAudit

-----------------------------------------------------


--part 2:
--mycompany
-- 1- Create a trigger that prevents the insertion Process for Employee table in March [MyCompany DB].
 create trigger preventinMarch
 on Employee
 instead of insert
 as 
 if format(GETDATE(),'MMMM') = 'March'
	select 'you cannot insert in March'
else 
	insert into Employee
	select * from inserted

insert into Employee (SSN , Lname ) values (1,'ALi') 


---------------------------------------------------

use sd32-company

-- - Create an Audit table with the following structure 
--    ProjectNo = p2
--    UserName  = Dbo
--    ModifiedDate = 2008-01-31
--    Budget_Old = 95000
--    Budget_New = 200000
-- This table will be used to audit the update trials on the Budget column (Project table, Company DB)
-- If a user updated the budget column then the project number, user name that made that update, 
-- the date of the modification and the value of the old and the new budget will be inserted into the Audit table
-- Note: This process will take place only if the user updated the budget column[Use SD32-Company]

	
Create table AuditUpdateOnBudget41
(
 ProjectNo int,
 UserName  varchar(50),
 ModifiedDate  date,
 Budget_Old  int,
 Budget_New int
)
create trigger hr.updateBudget41
on hr.Project
after update 
as
	if UPDATE(Budget)
	begin
	declare @pno int, @oldBudget int,@newBudget int
	select @pno = ProjectNo from inserted
	select @newBudget = Budget from inserted
	select @oldBudget = Budget from deleted
	insert into AuditUpdateOnBudget41
	values(@pno, SUSER_NAME(), GETDATE(), @oldBudget, @newBudget)

	end


update HR.Project
	set Budget = 222
	where ProjectNo = 1

select * from AuditUpdateOnBudget


--------------------------------------------

--part 3:
-- 1.	Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?
use ITI41 

create clustered index index1
on Department (Manager_hiredate)

--2.	Create an index that allows you to enter unique ages in the student table. What will happen?


create unique nonclustered index index2
on Student(st_age)

