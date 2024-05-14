/*======================================== Views ========================================*/

--Use ITI DB:
use iti
--1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 
create view dispalyStudents
as 
 select CONCAT(s.St_Fname , ' ' , s.St_Lname) [Full name] , c.Crs_Name [Course Name]
 from Student s , Course c , Stud_Course sc
 where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade > 50
	
--Run
select * from dispalyStudents

--2.	 Create an Encrypted view that displays manager(Instructors) names and the topics they teach. 
create or alter view InstructorTopics
with encryption
as 
select  i.Ins_Name , t.Top_Name
from Instructor i , Topic t , Ins_Course ic , Hr.Course c
where i.Ins_Id = ic.Ins_Id and c.Crs_Id = ic.Crs_Id and t.Top_Id = c.Top_Id
	
--Run
select * from InstructorTopics

--3.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
create view InstructorSD_Java
with schemabinding , encryption
as
	select i.Ins_Name , d.Dept_Name
	from dbo.Instructor i , dbo.Department d
	where i.Dept_Id = d.Dept_Id  and d.Dept_Name in ('SD' , 'Java')

--Run
select * from InstructorSD_Java

--4. Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--Note: Prevent the users to run the following query 
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

create or Alter view V1
with encryption
as
select *
from Student
where St_Address in ('Alex' , 'Cairo')
with check option
	
select* from V1

Update V1 set st_address='Tanta'
Where st_address='Alex';

--Run
select * from V1

--5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)
use MyCompany

create or alter view displayProject
as
  select p.Pname , COUNT(w.ESSn) [Number of Employee]
  from Project p , Works_for w
  where p.Pnumber = w.Pno
  group by p.Pname
	

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
 select ProjectNo , ProjectName
 from HR.Project
	

--Run
select * from v_without_budget

--3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it

create view v_count
as

 select p.ProjectName , COUNT(w.Job) [Number of jobs]
 from HR.Project p , Works_on w
 where p.ProjectNo = w.ProjectNo
 group by p.ProjectName
	

--Run
select * from v_count

--4.	 Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)
create view v_project_p2
as 
select v.EmpNo
from v_clerk v
where v.ProjectNo = 2
	

--Run
select * from v_project_p2

--5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.
alter view v_without_budget
as
 select *
 from HR.Project p
 where p.ProjectNo in (1,2)
	

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
select EmpLname
from displayEmp
where EmpLname like '%J%'

--9.	Create view named “v_dept” that will display the department# and department name
create view v_dept
as
select DeptNo [Department number] , DeptName [Department NAme]
from Department
	

--Run
select * from v_dept

--10) using the previous view try enter new department data where dept# is (d4) and dept name is ‘Development’

insert into v_dept values(4, 'Development')

--11) Create view name (v_2006_check) that will display employee Number, 
--    the project Number where he works and the date of joining the project 
--    which must be from the first of January and the last of December 2006.
--    this view will be used to insert data so make sure that the coming new data must match the condition

create or alter view v_2006_check
as 
select EmpNo [Employee Number], ProjectNo [Project number], Enter_Date
from Works_on w
where Enter_Date between '1-1-2006' and '12-31-2006'
with check option
	

--Run
select * from v_2006_check

insert into v_2006_check values(22222, 2, '1-2-2006') -- successful insertion
insert into v_2006_check values(22222, 1, '1-2-2007') -- failed because Date Range

/*============================================================================================================================*/
