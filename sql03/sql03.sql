
-- Assignment 3 sql:
---------------------------
--Part 01
-- Use ITI DB
-------------------
--1.	Retrieve a number of students who have a value in their age. 
select count(s.St_Id)
from Student s
where s.St_Age is not null

----------------------------------------------------------------------------------- 
--2.	Display number of courses for each topic name 
select t.Top_Name, COUNT(c.Crs_Id)
from Course c, Topic t
where t.Top_Id= c.Top_Id
group by t.Top_Name

----------------------------------------------------------------------------------- 
--3.	Select Student first name and the data of his supervisor
select s.St_Fname, super.*
from Student s, Student super
where s.St_super = super.St_Id
-----------------------------------------------------------------------------------  
--4.	Display student with the following Format (use isNull function)
--Student ID	Student Full Name	Department name

select s.St_Id [Student ID], CONCAT( ISNULL(s.St_Fname, 'not found'),' ', ISNULL(s.St_Lname, 'not found')) [Student Full Name], d.Dept_Name [Department name]
from Student s, Department d
where d.Dept_Id = s.Dept_Id
-------------------------------------------------------------------------------------
--5.	Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function” 
select Ins_Name, ISNULL(Salary, 0000) [salary]
from Instructor
----------------------------------------------------------------------------------- 
--6.	Select Supervisor first name and the count of students who supervises on them
select super.St_Fname , COUNT(s.St_Id)
from Student s, Student super
where s.St_super = super.St_Id
group by super.St_Fname
----------------------------------------------------------------------------------- 
--7.	Display max and min salary for instructors
select max(Salary) [max salary], min(Salary) [min salary]
from Instructor
----------------------------------------------------------------------------------- 
--8.	Select Average Salary for instructors 
select avg(Salary) [average salary]
from Instructor
----------------------------------------------------------------------------------- 
--9.	Display instructors who have salaries less than the average salary of all instructors.
select *
from Instructor
where Salary < (select avg(Salary) from Instructor)
----------------------------------------------------------------------------------- 
--10.	Display the Department name that contains the instructor who receives the minimum salary
select d.Dept_Name
from Department d, Instructor i
where d.Dept_Id= i.Dept_Id and i.Salary = (select min(Salary) from Instructor)
----------------------------------------------------------------------------------- 

--Part 02
--Use MyCompany DB
-----------------------
--DQL:
--1.	For each project, list the project name and the total hours per week (for all employees) spent on that project.
select  p.Pname, sum(w.Hours) [total hours/week]
from Project p, Works_for w
where p.Pnumber = w.Pno
group by p.Pname
----------------------------------------------------------------------------------- 
--2.	For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select d.Dname, max(e.Salary), min(e.Salary),avg(e.Salary)
from Employee e , Departments d
where d.Dnum = e.Dno
group by d.Dname
----------------------------------------------------------------------------------- 
--3.	Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, 
--first name.
select *
from Employee e, Project p, Works_for w
where e.SSN= w.ESSn and p.Pnumber= w.Pno
order by e.Dno, e.Lname, e.Fname
----------------------------------------------------------------------------------- 
--4.	Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 
update Employee
set salary += Salary*0.3
from Employee e, Project p, Works_for w
where e.SSN= w.ESSn and p.Pnumber= w.Pno and p.Pname = 'Al Rabwah' 
----------------------------------------------------------------------------------- 
--DML:

---- 00.Insert your personal data to the employee table as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee(ssn, Fname,Lname,Salary,Superssn,Dno)
values(102672, 'Manar', 'Maher', 3000, 112233, 30)
-------------------------------------------------------
-- 00. Insert another employee with your friend's personal data as new employee in department number 30, SSN = 102660, but don’t enter any value for salary 
--or manager number to him.
insert into Employee(ssn, Fname,Lname,Dno)
values(102660, 'Mostafa', 'Ali', 30)
---------------------------------------------------------------------
--1.	In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. 
--The start date for this manager is '1-11-2006'.
insert into Departments
values('DEPT IT', 100, 112233, '1-11-2006')
----------------------------------------------------------------------------------- 
--2.	Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of the new department (id = 100), 
--and they give you(your SSN =102672) her position (Dept. 20 manager) 

--a.	First try to update her record in the department table
update Departments
set MGRSSN = 968574
where Dnum = 100
----------------------------------------------------------------------------------- 
--b.	Update your record to be department 20 manager.
update Departments
set MGRSSN = 102672
where Dnum = 20
----------------------------------------------------------------------------------- 
--c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
update Employee
set Superssn = 102672
where ssn = 102660
----------------------------------------------------------------------------------- 
--3.	Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344) so try to delete him from your database in case you know that you will
--be temporarily in his position.
--Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises any employees or works in any projects and handles these cases).

delete from Dependent
where ESSN= 223344

update Departments
set MGRSSN = 102672
where MGRSSN= 223344

update Employee
set Superssn= 102672
where Superssn= 223344 

update Works_for 
set ESSn= 102672
where ESSn = 223344  

delete from Employee
where SSN = 223344
----------------------------------------------------------------------------------- 
--Part 03
--Using MyCompany:
----------------------
----------------------------------------------------------------------------------- 
--4.	Display the data of the department which has the smallest employee ID over all employees' ID.
select e.SSN,d.*
from Employee e, Departments d
where d.Dnum = e.Dno and e.SSN = (select min(e.SSN) from Employee e)
----------------------------------------------------------------------------------- 
--5.	List the last name of all managers who have no dependents
select e.Lname ,d.MGRSSN
from Employee e , Departments d
where e.SSN= d.MGRSSN and e.SSN not in (select dep.ESSN from Dependent dep)

----------------------------------------------------------------------------------- 
--6.	For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.
select d.Dnum, d.Dname, COUNT(e.SSN) [number of employees]
from Departments d, Employee e
where d.Dnum = e.Dno
group by d.Dnum, d.Dname
having AVG(e.Salary) < (select AVG(salary) from Employee)

----------------------------------------------------------------------------------- 
--7.	Try to get the max 2 salaries using subquery
select max(salary)
from Employee
union 
select max(salary)
from Employee
where Salary < (select max(salary) from Employee)


