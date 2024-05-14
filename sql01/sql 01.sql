

--Assignment 1 sql :
--------------------------


--1- from the 2 Database Schemas attached with the assignment Create One using code 
--and another using wizard and insert at least 2 rows per table. 

create database itiworkshop
use itiworkshop


create table Student(
id int primary key identity(1,1),
Fname varchar(20) not null,
Lname varchar(20) not null,
age int,
address varchar(50),
dept_id int
)

create table Department(
id int primary key identity(10,10),
name varchar(20) not null,
hireDate varchar(20),
inst_id int
)


create table Instructor(
id int primary key identity(1,1),
name varchar(20) not null,
salary decimal not null,
bonus int,
address varchar(50),
hourRate decimal,
dept_id int references Department(id)
)


create table Course(
id int primary key identity(1,1),
name varchar(20) not null,
duration int,
description varchar(50),
top_id int
)

create table Topic(
id int primary key identity(1,1),
name varchar(20) not null
)

create table Stud_Crs(
stud_id int references Student(id),
crs_id int references Course(id),
grade int,
primary key (stud_id,crs_id)
)



create table Inst_Crs(
inst_id int references Instructor(id),
crs_id int references Course(id),
evaluation int,
primary key (inst_id,crs_id)
)



alter table Student
add foreign key (dept_id) references Department(id) 

alter table Department 
add foreign key (inst_id) references Instructor(id)


alter table Course 
add foreign key (top_id) references Topic(id)




insert into Department
values
('CS','1-10-2022',null),
('AI','1-12-2022',null),
('Web','1-8-2022',null)

insert into Student
values
('Manar','Maher',25,null,10),
('Omar','Ahmad',30,null,20)

insert into Instructor 
values
('Ali',5000,null,null,null,20)



------------------------------------------------------------------------------------------------------------------------------------------------------
--2- Data Manipulating Language:

--1.Insert your personal data to the student table as a new Student in department number 30.

insert into Student (Fname, Lname, dept_id)
values('Mohamad','Gamal',30)

------------------------------------------------------------------------------------------------------------------------------------------------------

--2.Insert Instructor with personal data of your friend as new Instructor in department number 30, Salary= 4000, but don’t enter any value for bonus.

insert into Instructor (name, salary,dept_id)
values('Mona', 4000,30)



------------------------------------------------------------------------------------------------------------------------------------------------------

--3.Upgrade Instructor salary by 20 % of its last value.

update Instructor
set salary += salary*0.2
where dept_id = 30


update Instructor
set salary = salary*0.2
where dept_id = 20