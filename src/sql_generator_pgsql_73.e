note

	description:

		"Produces PostgreSQL 7.3 output."

	Known_bugs:
		"1. Add support for create type to create domains.%
		%2. Constants are parsed as float8 and do not map to numeric datatypes."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003-2014, Berend de Boer"

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

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "PostgreSQL 7.3.3"
		end


feature -- View options

	CreateViewSQL: STRING = "create or replace view "
			-- SQL statement to start creating a view; should end with
			-- some form of space


feature -- Stored procedure support

	drop_sp_type (a_procedure: XPLAIN_PROCEDURE)
			-- Drop the type of records the procedure
			-- returns. Unfortunately we cannot test if the type exists
			-- so you have to ignore the error message if the type does
			-- not exist.
		require
			procedure_not_void: a_procedure /= Void
			procedure_returns_rows: a_procedure.returns_rows (Current)
		do
			std.output.put_string (once "drop type ")
			std.output.put_string (sp_type_name (a_procedure))
			std.output.put_string (once " cascade")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	create_sp_type (a_procedure: XPLAIN_PROCEDURE)
			-- Create the type of records the procedure returns.
		require
			procedure_not_void: a_procedure /= Void
			procedure_returns_rows: a_procedure.returns_rows (Current)
		do
			std.output.put_string (once "create type ")
			std.output.put_string (sp_type_name (a_procedure))
			std.output.put_string (once " as (")
			std.output.put_string (a_procedure.sp_function_type (Current, a_procedure.is_path_procedure))
			std.output.put_character (')')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_result_parameter (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Emit the result parameter of the stored procedure, if
			-- applicable.
		do
			if attached a_procedure as p then
				if p.is_postgresql_trigger then
					if p.returns_rows (Current) then
						std.error.put_line ("ERROR: trigger procedure returns rows.")
					elseif p.returns_value (Current) then
						std.error.put_line ("ERROR: trigger procedure returns a value.")
					end
					if p.parameters.count > 0 then
						std.error.put_line ("ERROR: trigger procedure has parameters. Use the `new' variable to access the new row and the `old' variable to access the old row.")
					end
					std.output.put_string (once " returns trigger")
				elseif p.returns_rows (Current) then
					std.output.put_string (once " returns setof ")
					std.output.put_string (sp_type_name (p))
				elseif p.returns_value (current) then
					std.output.put_string (once " returns ")
					if attached p.last_value_selection_statement as statement then
						std.output.put_string (statement.value.representation.datatype (Current))
					end
				else
					std.output.put_string (once " returns void")
				end
			else
				std.output.put_string (once " returns void")
			end
		end

	sp_return_cursor
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

	sp_start (a_procedure: detachable XPLAIN_PROCEDURE)
			-- Write statements to start a procedure, including the
			-- "create procedure " statement itself (including space).
		do
			if attached a_procedure as p and then p.returns_rows (Current) then
				drop_sp_type (p)
				create_sp_type (p)
				std.output.put_character ('%N')
			end
			is_stored_procedure := True
			std.output.put_string ("create or replace function ")
		end

	sp_start_cursor
			-- Code that starts a cursor for a select statement.
			-- Only one select statement is allowed per procedure.
		do
			std.output.put_string ("for result_cursor in")
			CommandSeparator.wipe_out
		end

	sp_type_name (a_procedure: XPLAIN_PROCEDURE): STRING
			-- Name of type that is result of a function that returns sets.
		do
			Result := a_procedure.quoted_name (Current)
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Emit value declarations.
		do
			precursor (procedure)
			if procedure.returns_rows (Current) then
				std.output.put_string (Tab)
				std.output.put_string ("result_cursor ")
				std.output.put_string (sp_type_name (procedure))
				std.output.put_string ("%%rowtype")
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end


end
