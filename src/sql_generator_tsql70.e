note

	description:

		"Produces output for Microsoft SQL Server 7.0"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #12 $"

	known_bugs:
		"0. See inherited bugs..."


class

	SQL_GENERATOR_TSQL70

inherit

	SQL_GENERATOR_TSQL
		redefine
			asserted_format_string,
			CalculatedColumnsSupported,
			conditional_drop_procedure,
			do_create_value_assign,
			drop_table_if_exist,
			quote_identifier,
			sql_expression_as_boolean_value,
			sql_select_function_limit_before,
			SQLFalse,
			sqlfunction_some,
			SQLTrue,
			sp_body_start,
			sp_user_result
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "MS SQL Server Transact SQL 7.0"
		end


feature -- Identifiers

	MaxIdentifierLength: INTEGER
		once
			Result := 128
		end

	MaxTemporaryTableNameLength: INTEGER
		once
			Result := 116
		end

	quote_identifier (identifier: STRING): STRING
			-- return identifier, surrounded by brackets
		local
			s: STRING
		do
			s := "[" + identifier + "]"
			Result := s
		end


feature -- Assertions

	CalculatedColumnsSupported: Boolean = True

	asserted_format_string: STRING
		once
			Result := "as $s"
		end


feature -- Booleans

	SQLTrue: STRING
		once
			Result := "cast(1 as bit)"
		end

	SQLFalse: STRING
		once
			Result := "cast(0 as bit)"
		end


feature -- TransactSQL specific SQL creation statements

	do_create_value_assign (a_value: XPLAIN_VALUE)
			-- Assign a value to `a_value'.
		do
			std.output.put_string ("set ")
			std.output.put_string (value_identifier (a_value))
			std.output.put_string (" = (")
			std.output.put_string (a_value.expression.outer_sqlvalue (Current))
			std.output.put_character (')')
			std.output.put_character ('%N')
		end


feature -- drop statements

	drop_table_if_exist (type: XPLAIN_TYPE)
			-- TSQL 7 specific drop statement
		do
			std.output.put_string ("if exists (select * from sysobjects where id = object_id('dbo.")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string ("') and OBJECTPROPERTY(id, N'IsUserTable') = 1)%N")
			std.output.put_string ("begin%N")
			drop_table (type)
			std.output.put_string ("end")
			end_with_go
		end


feature -- functions

	sqlfunction_some: STRING once Result := "top 1" end


feature -- Extension

	sql_expression_as_boolean_value (expression: XPLAIN_EXPRESSION): STRING
			-- Return SQL code for extension that is a logical
			-- expression. For SQL dialects that don't support Booleans,
			-- it might need to map the Boolean result to a 'T' or 'F'
			-- value.
		do
			if expression.is_logical_constant then
				--Result := format ("case when $s = $s then cast(1 as bit) else cast(0 as bit) end", <<expression.sqlvalue (Current), SQLTrue>>)
				Result := expression.sqlvalue (Current)
			else
				Result := format ("case when $s then cast(1 as bit) else cast(0 as bit) end", <<expression.sqlvalue (Current)>>)
			end
		end


feature -- Return sql code

	sql_select_function_limit_before (selection_list: XPLAIN_SELECTION_FUNCTION): STRING
			-- Code that limits a select to return a single value.
			-- Returns empty for no output.
		do
			-- Because Transact SQL implements `sqlfunction_some', we
			-- don't want the distinct function. It severely affects
			-- performance as well.
			Result := ""
		end


feature -- Stored procedure support

	conditional_drop_procedure (name: STRING)
			-- Drop procedure, but only if it exists, should never
			-- generate an error or warning.
		do
			std.output.put_string ("if exists (select * from sysobjects where id = object_id(N'[dbo].")
			std.output.put_string (name)
			std.output.put_string ("') and OBJECTPROPERTY(id, N'IsProcedure') = 1)%N")
			do_drop_procedure (name)
			end_with_go
		end

	sp_body_start
			-- Begin a procedure body.
			-- Should leave cursor on a new line.
			-- For Transact SQL 7 we abort a stored procedure on any
			-- error executing a statement inside it, and rollback the
			-- transaction.
		do
			std.output.put_string ("%N")
			std.output.put_string ("set xact_abort on%N")
		end

	sp_user_result (procedure: XPLAIN_PROCEDURE)
			-- Output any stuff before header ends. Result parameter, if
			-- any has been written.
		do
			if procedure.recompile then
				std.output.put_string (" with recompile")
			end
		end


end
