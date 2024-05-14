/*======================================== Assignment 07 ========================================*/

/*== Part 01 (Functions) ==*/

--Use ITI DB:
use ITI
--1.	Create a scalar function that takes a date and returns the Month name of that date.
Create function getMonth(@date date)
returns varchar(20)
begin 
	return FORMAT(@date , 'MMMM')
end

--Run
select dbo.getMonth(getdate())

--2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
create function getValuesBetween(@X int , @Y int)
returns @table table (valueINBetween int )
as
begin	
	while(@X < @Y - 1)
		begin 
			set @X += 1
			insert into @table values(@X)
		end
	return
end
--Run
select * from getValuesBetween(1,10)

--3.	 Create a table-valued function that takes Student No and returns Department Name with Student full name.
Create function getDeptName(@studentNo int)
returns @table table  ( fullName varchar(50),deptName varchar(20) )
as
begin 
	insert into @table
	select CONCAT(S.St_Fname ,' ', S.St_Lname) [Full Name], D.Dept_Name
	from  Department D ,Student S 
	where D.Dept_Id = S.Dept_Id
	and S.St_Id = @studentNo
	return
end
--Run
select * from getDeptName(9)

--4.	Create a scalar function that takes Student ID and returns a message to user 
	--a.	If first name and Last name are null then display 'First name & last name are null'
	--b.	If First name is null then display 'first name is null'
	--c.	If Last name is null then display 'last name is null'
	--d.	Else display 'First name & last name are not null'
	create function ShowMSG(@studentNo int)
returns varchar(50)
begin 
	declare @Msg varchar(50)
	declare @fName varchar(50)
	declare @lName varchar(50)
	select @fName = S.St_Fname, @lName = S.St_Lname from Student S
	where S.St_Id = @studentNo

	if(@fName is null) and (@lName is null)
		select @Msg = 'First name & last name are null'
	else if (@fName is null)
		select @Msg = 'First name is null'
	else if (@lName is null)
		select @Msg = 'Last name is null'
	else 
		select @Msg = 'First name & last name are not null'
	return @Msg
end

--Run
select dbo.ShowMSG(1) -- First name & last name are not null

--5.	Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.  
create function ManagerFormHiringDate(@format int)
returns @table table
(
	deptName varchar(50),
	mangerName varchar(50),
	hiringDate varchar(50)
)
as 
begin 
	insert into @table
	select D.Dept_Name, I.Ins_Name, convert(varchar, D.Manager_hiredate, @format)
	from Instructor I, Department D
	where D.Dept_Id = I.Dept_Id
	return
end
--Run
select * from ManagerFormHiringDate(111)

--6.	Create multi-statement table-valued function that takes a string
	--a.	If string='first name' returns student first name
	--b.	If string='last name' returns student last name 
	--c.	If string='full name' returns Full Name from student table  (Note: Use “ISNULL” function)
create function getStudentName(@str varchar(20))
returns @table table (
	Student_Name varchar(20)
)
as
begin
	if(@str = 'first name')
		insert into @table
		select ISNULL(S.St_Fname, 'Not Found') 
		from Student S
	else if(@str = 'last name')
		insert into @table
		select ISNULL(S.St_Lname, 'Not Found') 
		from Student S
	else if(@str = 'full name')
		insert into @table
		select ISNULL(S.St_Lname, 'Not Found') + ISNULL(S.St_Lname, 'Not Found') 
		from Student S
	return
end

select * from getStudentName('full name')

--7.	Create function that takes project number and display all employees in this project (Use MyCompany DB)
Use MyCompany

alter function getAllEmployees(@projectNo int)
returns @table table ( [Employee Name] varchar(50) )
as 

begin 
	insert into @table
	select CONCAT(E.Fname , E.Lname)
	from Employee E, Project P, Works_for W
	where P.Pnumber = W.Pno 
	and E.SSN = W.ESSn
	and P.Pnumber = @projectNo
	return 
end
--Run 
select * from getAllEmployees(100)

/*============================================================================================================================*/

/*== Part 02 (Views) ==*/
--Use ITI DB:
use iti
--1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 
create view dispalyStudents
as 
	select CONCAT(S.St_Fname ,S.St_Lname) as [Full Name], C.Crs_Name [Course Name]
	from  student S , Course C, Stud_Course SC  
	where S.St_Id = SC.St_Id 
	and C.Crs_Id = SC.Crs_Id
	and SC.Grade > 50
--Run
select * from dispalyStudents

--2.	 Create an Encrypted view that displays manager names and the topics they teach. 
create view InstructorTopics
with encryption
as 
	select distinct I.Ins_Name, T.Top_Name
	from Instructor I, Topic T, Ins_Course IC, Course C
	where I.Ins_Id = IC.Ins_Id
	and C.Crs_Id = IC.Crs_Id 
	and T.Top_Id = C.Top_Id

--Run
select * from InstructorTopics

--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
create view InstructorSD_Java
with schemabinding , encryption
as

	select I.Ins_Name, D.Dept_Name
	from dbo.Instructor I , dbo.Department D
	where I.Dept_Id = D.Dept_Id
	and D.Dept_Name in ('SD', 'Java')

--Run
select * from InstructorSD_Java

--4. Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

create view V1
with encryption
as
	select *
	from Student
	where St_Address in ('Alex', 'cairo')
	with check option

Update V1 set st_address='Tanta'
Where st_address='Alex';

--Run
select * from V1

--5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)
use MyCompany

create view displayProject
as
	select P.Pname, count(W.ESSn) as [Number Of Employees]
	from Project P, Works_for W
	where P.Pnumber = W.Pno
	group by P.Pname

--Run
select * from displayProject

-- Part 2
--use CompanySD32_DB:
use [SD32-Company]
--1.	Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'.
create view v_clerk
as
	select EmpNo , ProjectNo , Enter_Date
	from Works_on
	where Job = 'Clerk'

--Run
select * from v_clerk

--2.	 Create view named  “v_without_budget” that will display all the projects data without budget

create view v_without_budget
as
	select ProjectNo, ProjectName
	from HR.Project

--Run
select * from v_without_budget

--3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it

create view v_count
as
	select P.ProjectName, count(W.Job) as [Number of Jobs]
	from HR.Project P , Works_on W
	where P.ProjectNo = W.ProjectNo
	group by P.ProjectName

--Run
select * from v_count

--4.	 Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)
create view v_project_p2
as 
	select v.EmpNo [Employee Number] 
	from v_clerk V
	where V.ProjectNo = 2

--Run
select * from v_project_p2

--5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.
alter view v_without_budget
as
	select *
	from HR.Project P
	where P.ProjectNo in (1, 2)

select * from v_without_budget
--6.	Delete the views  “v_ clerk” and “v_count”
drop view v_clerk, v_count

--7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
create view displayEmp
as
	select EmpNo , EmpLname 
	from HR.Employee
	where DeptNo = 2
--Run
select * from displayEmp
--8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
select E.EmpLname
from displayEmp E
where E.EmpLname like '%j%'
--9.	Create view named “v_dept” that will display the department# and department name
create view v_dept
as
	select DeptNo [Department Num], DeptName [Department Name]
	from Department

--Run
select * from v_dept

--10) using the previous view try enter new department data where dept# is (d4) and dept name is ‘Development’

insert into v_dept values(4, 'Development')

--11) Create view name (v_2006_check) that will display employee Number, 
--    the project Number where he works and the date of joining the project 
--    which must be from the first of January and the last of December 2006.
--    this view will be used to insert data so make sure that the coming new data must match the condition

create view v_2006_check
as 
	select EmpNo [Employee Number], ProjectNo [Project Number], Enter_Date [Joining Date]
	from Works_on
	where Enter_Date between '2006-1-1' and '2006-12-30'
	with check option

--Run
select * from v_2006_check

insert into v_2006_check values(22222, 2, '2006-2-1') -- successful insertion
insert into v_2006_check values(22222, 1, '2007-2-1') -- failed because Date Range

/*============================================================================================================================*/
