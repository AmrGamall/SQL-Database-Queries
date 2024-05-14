--Part 05

--Use ITI DB :
use ITI
--•	Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?
use iti 

create clustered index myIndex
on Department(Manger_hireDate)

--•	Create an index that allows you to enter unique ages in the student table. What will happen?

create unique index MyIndex02
on Student (St_Age)

--- can't create unique index because  there is duplicate key in the colunm (St_Age)

--•	Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB then allow him to select and insert data into tables and deny Delete and update
-- [Login]          Server (RouteStudent)
-- [User]           DB ITI (RouteStudent)
-- [Schema]         HR   [Student, Course]
-- Permissions      Grant [select,insert]    Deny [delete Update]
----------------------------------------------------------------------------------------------------

create Schema Hr

alter Schema Hr Transfer [dbo].[Student]

alter Schema Hr Transfer [dbo].[Course]