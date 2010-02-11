@echo off

if "%1" == "" goto noscript

echo Testing %1

rem test Microsoft SQL Server against a single test

rem SQL Server settings: uses local server
set ISQL=osql
set ISQL_USERNAME=sa
set ISQL_PASSWORD=
@rem ISQL_OPTIONS=-b -U %ISQL_USERNAME% -P %ISQL_PASSWORD% -r
set ISQL_OPTIONS=-b -E -r

rem Xplain settings
set OPTIONS=-tsql

rem make sql file
xplain2sql %OPTIONS% ..\samples\%1.ddl > ..\samples\%1.sql
if errorlevel 1 goto error

rem drop database
%ISQL% %ISQL_OPTIONS% -Q "drop database %1"

rem create database
%ISQL% %ISQL_OPTIONS% -Q "create database %1"
if errorlevel 1 goto error

rem run scripts
%ISQL% %ISQL_OPTIONS% -i ..\samples\%1.sql -o ..\samples\%1.out
if errorlevel 1 goto error

rem drop database
%ISQL% %ISQL_OPTIONS% -Q "drop database %1"

goto end


:error
echo Some error occurred.
pause
goto end

:noscript
echo You have to supply a script name. Example:
echo   dotsql bank
goto end

:end
