note

	description:

		"Produces output for Microsoft SQL Server 6.5."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

	known_bugs:
	"0. See inherited bugs...%
	%1. Boolean columns are always required for SQL Server 6.5%
	%   should force them to be required.%
	%2. SQL Server 6.5 doesn't support dropping columns. You're not warned."

class

	SQL_GENERATOR_TSQL65

inherit

	SQL_GENERATOR_TSQL
		redefine
			SQLCoalesce,
			quote_identifier,
			drop_table_if_exist
		end

create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "MS SQL Server Transact SQL 6.5"
		end


feature -- functions

	SQLCoalesce: STRING
			-- MS SQL Server 6.5 dumps core with coalesce function
		once
			Result := "IsNull"
		end


feature -- identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 30
		end

	MaxTemporaryTableNameLength: INTEGER
		once
			Result := 20
		end

	quote_identifier (identifier: STRING): STRING
			-- return identifier, surrounded by quotes
		local
			s: STRING
		do
			s := "%"" + identifier + "%""
			Result := s
		end


feature -- drop statements

		drop_table_if_exist (type: XPLAIN_TYPE)
			-- TSQL 6.5 specific drop statement
		do
			print ("if exists (select * from sysobjects where id = object_id('dbo.")
			print (type.sqltablename (Current))
			print ("') and sysstat & 0xf = 3)%N")
			print ("begin")
			drop_table (type)
			print ("end")
			end_with_go
		end


end
