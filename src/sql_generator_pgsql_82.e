note

	description:

		"Produces PostgreSQL 8.2 output."

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"


class

	SQL_GENERATOR_PGSQL_82


inherit

	SQL_GENERATOR_PGSQL_81
		redefine
			drop_sp_type,
			target_name
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "PostgreSQL 8.2"
		end


feature -- Stored procedure support

	drop_sp_type (a_procedure: XPLAIN_PROCEDURE)
			-- Drop the type of records the procedure
			-- returns. Unfortunately we cannot test if the type exists
			-- so you have to ignore the error message if the type does
			-- not exist.
		do
			std.output.put_string (once "drop type if exists ")
			std.output.put_string (sp_type_name (a_procedure))
			std.output.put_string (once " cascade")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end



end
