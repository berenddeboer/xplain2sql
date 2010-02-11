# Employee example, chapter 6 in Semantic Data Modeling.

# Changes:
# 1. 'of' is a keyword within xplain2sql, so 'number of employees' had 
#    to be changed to 'numberofemployees'.


database employee.


# First the DDL.

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


# Example 1: Select data of the employee with the identification E3.

get employee "E3".


# Example 2: Select employees living in Guilding.

get employee its name, department
    where home_town = "Guilding".


# Example 3: Select commuters.

get employee its name, home_town, department
    where home_town <> department its business_town.


# Example 4: How many employees work in Guilding?

get count employee
    where department its business_town = "Guilding".


# Example 5: What is the sum of all salaries?

get total employee its salary.


# Example 6: What is the highest salary?

get max employee its salary.


# Example 7: Are there any employees earning more than 50.000?

get any employee 
    where salary > 50000.


# Example 8: Select the name of an arbitrary employee in the 
# Purchase department.

get some employee its name
    where department its department name = "Purchase".


# Example 9: Provide an overview of the departments, including the
# number of employees.

extend department with numberofemployees=
    count employee
    per department.

get department its 
    department name, 
    business_town, 
    numberofemployees.


# Example 10: Select departments with more than 100 employees.

get department its 
    department name, 
    business_town
  where 
    numberofemployees > 100.


# Example 11: Find the number of departments with more than 100
# employees.

get count department
  where numberofemployees > 100.


# Example 12: Which department has the most employees?

value maximum =
    max department its numberofemployees.

get department its 
    department name, 
    business_town
  where 
    numberofemployees = maximum.

end.
