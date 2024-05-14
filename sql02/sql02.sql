
-- Assignment 2 sql:
-----------------------------
--Part 1:
--MyCompany:
-------------
--1.	Display all the employees Data.
select *
from Employee
-----------------------------------------------------------------------------------
--2.	Display the employee First name, last name, Salary and Department number.
select e.Fname, e.Lname, e.Salary, e.Dno
from Employee e
-----------------------------------------------------------------------------------
--3.	Display all the projects names, locations and the department which is responsible for it.
select p.Pname, p.Plocation, d.Dname
from Project p, Departments d
where d.Dnum = p.Dnum

-----------------------------------------------------------------------------------
--4.	If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary 
--.Display each employee full name and his annual commission in an ANNUAL COMM column (alias).

select concat(e.Fname,' ', e.Lname) [Full Name], salary *12 *0.1 [annual comm]
from Employee e
-----------------------------------------------------------------------------------
--5.	Display the employees Id, name who earns more than 1000 LE monthly.
select e.SSN, e.Fname, e.Salary
from Employee e
where Salary > 1000

-----------------------------------------------------------------------------------
--6.	Display the employees Id, name who earns more than 10000 LE annually.
select e.SSN, e.Fname, e.Salary*12 [annual salary]
from Employee e
where Salary*12 > 10000

-----------------------------------------------------------------------------------
--7.	Display the names and salaries of the female employees 
select concat(e.Fname,' ', e.Lname) [Full Name], Salary
from Employee e
where e.Sex = 'F'
-----------------------------------------------------------------------------------
--8.	Display each department id, name which is managed by a manager with id equals 968574.

select d.Dnum, d.Dname
from Departments d
where d.MGRSSN = 968574

-----------------------------------------------------------------------------------
--9.	Display the ids, names and locations of  the projects which are controlled with department 10.
select p.Pnumber, p.Pname, p.Plocation
from Project p
where p.Dnum = 10

-----------------------------------------------------------------------------------

--Part 2:
--ITI:
-------------
--1.	Get all instructors Names without repetition
select distinct (i.Ins_Name)
from Instructor i

-----------------------------------------------------------------------------------
--2.	Display instructor Name and Department Name.Note: display all the instructors if they are attached to a department or not

select i.Ins_Name, d.Dept_Name
from Instructor i left join Department d
on d.Dept_Id = i.Dept_Id
-----------------------------------------------------------------------------------
--3.	Display student full name and the name of the course he is taking For only courses which have a grade 
select s.St_Fname+' '+s.St_Lname [full name], c.Crs_Name, sc.Grade
from Student s, Course c, Stud_Course sc
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id and sc.Grade is not null

----------------------------------------------------------------------------------- 
--Bouns
--Display results of the following two statements and explain what is the meaning of @@AnyExpression


select @@VERSION

select @@SERVERNAME



-----------------------------------------------------------------------------------
--Part 3:
--MyCompany:
-------------
--1.	Display the Department id, name and id and the name of its manager.
select d.Dnum, d.Dname, d.MGRSSN, e.Fname
from Departments d, Employee e
where e.SSN = d.MGRSSN

----------------------------------------------------------------------------------- 
--2.	Display the name of the departments and the name of the projects under its control.
select d.Dname, p.Pname
from Departments d, Project p
where d.Dnum = p.Dnum
----------------------------------------------------------------------------------- 
--3.	Display the full data about all the dependence associated with the name of the employee they depend on .
select d.*, e.Fname
from Employee e , Dependent d
where e.SSN = d.ESSN

----------------------------------------------------------------------------------- 
--4.	Display the Id, name and location of the projects in Cairo or Alex city.
select p.Pnumber, p.Pname, p.Plocation, p.City
from Project p
where p.City in ('Cairo','Alex')

----------------------------------------------------------------------------------- 
--5.	Display the Projects full data of the projects with a name starting with "a" letter.
select *
from Project p
where p.Pname like 'a%'


----------------------------------------------------------------------------------- 
--6.	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select * 
from Employee
where Dno=30 and salary between 1000 and 2000

----------------------------------------------------------------------------------- 
--7.	Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
select e.Fname+' '+e.Lname [full name]
from Employee e, Project p, Works_for w
where e.SSN= w.ESSn and p.Pnumber = w.Pno and e.Dno = 10 and w.Hours >= 10 and p.Pname='AL Rabwah'

----------------------------------------------------------------------------------- 
--8.	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select e.Fname+' '+e.Lname [full name] , p.Pname
from Employee e, Project p, Works_for w
where e.SSN= w.ESSn and p.Pnumber = w.Pno
order by p.Pname
----------------------------------------------------------------------------------- 
--9.	For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.
select p.Pnumber, d.Dname, e.Lname, e.Address, e.Bdate
from Project p, Departments d, Employee e
where d.Dnum=p.Dnum and e.SSN= d.MGRSSN and p.City='Cairo'
----------------------------------------------------------------------------------- 
--10.	Find the names of the employees who were directly supervised by Kamel Mohamed.
select e.Fname+' '+e.Lname [full name]
from Employee e, Employee super
where super.SSN = e.Superssn and super.Fname = 'Kamel' and super.Lname='Mohamed'

----------------------------------------------------------------------------------- 
--11.	Display All Data of the managers
select e.*
from Employee e, Departments d
where e.SSN = d.MGRSSN
----------------------------------------------------------------------------------- 
--12.	Display All Employees data and the data of their dependents even if they have no dependents.
select *
from Employee e left join Dependent d
on e.SSN = d.ESSN
