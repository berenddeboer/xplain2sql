note

	description:
		"Produces PostgreSQL 7.2 output."

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	SQL_GENERATOR_PGSQL_72


inherit

	SQL_GENERATOR_PGSQL
		redefine
			sp_before_end_delete,
			sp_before_end_update,
			sp_start,
			sp_user_declaration,
			make_valid_identifier
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "PostgreSQL 7.2"
		end


feature -- Stored procedure support

	sp_before_end_delete
		do
			std.output.put_string (Tab)
			std.output.put_string ("return 0")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_before_end_update
			-- Chance to emit something just before `sp_end' is called in
			-- `create_sp_update'.
		do
			std.output.put_string (Tab)
			std.output.put_string ("return 0")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

	sp_result_parameter (a_procedure: XPLAIN_PROCEDURE)
			-- Emit the result parameter of the stored procedure, if
			-- applicable.
			-- For example DB/2/Oracle needs to know if rows are returned.
		do
			if a_procedure /= Void and then a_procedure.returns_rows then
				std.output.put_string (" returns ")
				std.output.put_string (sp_type_name (a_procedure))
			else
				std.output.put_string (" returns void")
			end
		end

	sp_return_cursor
			-- Code that returns all rows in a cursor to a client.
			-- Only one select statement is allowed per procedure.
		do
			CommandSeparator.append_character (';')
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
			std.output.put_string ("return result_cursor")
		end

	sp_start (a_procedure: XPLAIN_PROCEDURE)
			-- Write statements to start a procedure, including the
			-- "create procedure " statement itself (including space).
		do
			is_stored_procedure := True
			std.output.put_string ("create function ")
		end

	sp_start_cursor
			-- Code that starts a cursor for a select statement.
			-- Only one select statement is allowed per procedure.
		do
			std.output.put_string ("open result_cursor for")
			CommandSeparator.wipe_out
		end

	sp_type_name (a_procedure: XPLAIN_PROCEDURE): STRING
			-- Name of type that is result of a function that returns sets.
		once
			Result := "refcursor"
		end

	sp_user_declaration (procedure: XPLAIN_PROCEDURE)
			-- Emit value declarations.
		do
			precursor (procedure)
			if procedure.returns_rows then
				std.output.put_string (Tab)
				std.output.put_string ("result_cursor ")
				std.output.put_string (sp_type_name (procedure))
				std.output.put_string (CommandSeparator)
				std.output.put_character ('%N')
			end
		end


feature -- Identifiers

	renamed_name: STRING = "name_"
	renamed_time: STRING = "time_"

	make_valid_identifier (name: STRING): STRING
			-- Rename the PostgreSQL keywords time and name.
		do
			Result := precursor (name)
			if name.is_equal ("time") then
				Result := renamed_time
			elseif name.is_equal ("name") then
				Result := renamed_name
			end
		end

end
