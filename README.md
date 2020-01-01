# About

xplain2sql converts Xplain to various dialects of SQL. Xplain is the
best and easiest data modeling language known to mankind.

xplain2sql is used to convert Xplain to various SQL dialects. It
optionally also can generate a `.xml` description of the file, which
can be used for various code generation purposes, like writing wrapper
to access the data, or generating a GraphQL schema.

# Usage

Convert an Xplain file:

    xplain2sql -mysql example.ddl

# Installation

Either [download a
binary](http://www.berenddeboer.net/xplain2sql/index.html#downloadofficial)
or the [C source
tarball](http://www.berenddeboer.net/xplain2sql/xplain2sql-5.0.1-csrc.tar.gz).

If you downloaded the tarball, you generate a binary with:

````
tar xvf xplain2sql-5.0.1-csrc.tar.gz
cd xplain2sql-5.0.1
make
````


# Xplain example

Employee database example:

    database employee.

    # First the DDL.

    base department name (A30).
    base town (A30).
    base name (A30).
    base salary (R9,2).

    type department (A3)  = department name, business_town.
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


# Learning Xplain

See the [Johan ter Bekke tribute site](http://www.jhterbekke.net/) for
many articles and contributions about the Xplain language.


# More about xplain2sql

The xplain2sql support page is http://www.berenddeboer.net/xplain2sql/.

There is [an extensive manual](doc/xplain2sql.pdf) covering use of the
tool, its internals and many examples.



# Compiling xplain2sql

Requirements, either:

1. ISE Eiffel 19.12.

2 Latest [Gobo](https://github.com/gobo-eiffel/gobo).

If you use ISE Eiffel, you can open `src/xplain2sql.ecf` with ISE
Studio and compile the project.

If you use the command-line, compile with `geant compile_ge` to
compile with Gobo or `geant compile_ise` to compile with ISE.



# Development status #

[![Build Status](https://api.travis-ci.org/berenddeboer/xplain2sql.svg?branch=master)](https://travis-ci.org/berenddeboer/xplain2sql/)
