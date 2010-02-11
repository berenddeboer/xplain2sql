#
# Some ingenious uses of inline SQL and Xplain code.
# Because of inline SQL, this example works only with Transact-SQL.
#

# test stored procedure parameters

database employee.


# data definition

base department name (A30).
base town (A30).
base name (A30).
base salary (R9,2).

type department	(A3)  = department name, business_town.
type employee (A3)    = name, home_town, department, salary.


# Define some departments and employees.

insert department "D1" its 
    department name = "Factory", 
    business_town = "Guilding".

insert employee "E1" its 
    name = "Mr. Johnson", 
    home_town = "London",
    department = "D1",
    salary = 1600.

insert employee "E3" its 
    name = "Mr. Test", 
    home_town = "Guilding",
    department = "D1",
    salary = 1500.


{
go
create procedure sp_all_employees as
}

get employee.
{
go
}


{
go
create procedure sp_department_by_name (@name Tdepartment_name) as
}
value myname = :name.

get department where department name = myname.

{
go
}


{
create procedure sp_employee_by_name (@name Tname) as
}
get employee where name = :name.

{
go
}


end.