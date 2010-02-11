indexing

	description:

		"Produces PostgreSQL 7.3 output."

	Known_bugs:
		"1. Add support for create type to create domains.%
		%2. Constants are parsed as float8 and do not map to numeric datatypes."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #7 $"

class

	SQL_GENERATOR_PGSQL_73


inherit

	SQL_GENERATOR_PGSQL
		redefine
			CreateViewSQL,
			sp_start,
			sp_user_declaration
		end


create

	make


feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "PostgreSQL 7.3.3"
		end


feature -- Table options

	CreateViewSQL: STRING is "create or replace view "
			-- SQL statement to start creating a view; should end with
			-- some form of space


feature -- Stored procedure support

	drop_sp_type (a_procedure: XPLAIN_PROCEDURE) is
			-- Drop the type of records the procedure
			-- returns. Unfortunately we cannot test if the type exists
			-- so you have to ignore the error message if the type does
			-- not exist.
		require
			procedure_not_void: a_procedure /= Void
			procedure_returns_rows: a_procedure.returns_rows
		do
			std.output.put_string (once "drop type ")
			std.output.put_string (sp_type_name (a_procedure))
			std.output.put_string (once " cascade")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_sp_type (a_procedure: XPLAIN_PROCEDURE) is
			-- Create the type of records the procedure returns.
		require
			procedure_not_void: a_procedure /= Void
			procedure_returns_rows: a_procedure.returns_rows
		do
			std.output.put_string (once "create type ")
			std.output.put_string (sp_type_name (a_procedure))
			std.output.put_string (once " as (")
			std.output.put_string (a_procedure.sp_function_type (Current, a_procedure.is_path_procedure))
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_result_parameter (a_procedure: XPLAIN_PROCEDURE) is
			-- Emit the result parameter of the stored procedure, if
			-- applicable.
			-- For example DB/2/Oracle needs to know if rows are returned.
		do
			if a_procedure /= Void then
				if a_procedure.is_postgresql_trigger then
					if a_procedure.returns_rows then
						std.error.put_line ("ERROR: trigger procedure returns rows")
					end
					if a_procedure.parameters.count > 0 then
						std.error.put_line ("ERROR: trigger procedure has parameters")
					end
					std.output.put_string (once " returns trigger")
				elseif a_procedure.returns_rows then
					std.output.put_string (once " returns setof ")
					std.output.put_string (sp_type_name (a_procedure))
				else
					std.output.put_string (once " returns void")
				end
			else
				std.output.put_string (once " returns void")
			end
		end

	sp_return_cursor is
			-- Code that returns all rows in a cursor to a client.
			-- Only one select statement is allowed per procedure.
		do
			CommandSeparator.append_character (';')
			std.output.put_string (once "loop%N")
			std.output.put_string (Tab)
			std.output.put_string (once "return next result_cursor")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string (once "end loop")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string (once "return")
		end

	sp_start (a_procedure: XPLAIN_PROCEDURE) is
			-- Write statements to start a procedure, including the
			-- "create procedure " statement itself (including space).
		do
			if a_procedure /= Void and then a_procedure.returns_rows then
				drop_sp_type (a_procedure)
				create_sp_type (a_procedure)
				std.output.put_character ('%N')
			end
			is_stored_procedure := True
			std.output.put_string ("create or replace function ")
		end

	sp_start_cursor is
			-- Code that starts a cursor for a select statement.
			-- Only one select statement is allowed per procedure.
		do
			std.output.put_string ("for result_cursor in")
			CommandSeparator.wipe_out
		end

	sp_type_name (a_procedure: XPLAIN_PROCEDURE): STRING is
			-- Name of type that is result of a function that returns sets.
		do
			Result := a_procedure.quoted_name (Current)
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE) is
			-- Emit value declarations.
		do
			precursor (procedure)
			if procedure.returns_rows then
				std.output.put_string (Tab)
				std.output.put_string ("result_cursor ")
				std.output.put_string (sp_type_name (procedure))
				std.output.put_string ("%%rowtype")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end


end
