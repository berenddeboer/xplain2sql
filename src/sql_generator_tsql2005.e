note

	description:

		"SQL for Microsoft SQL Server 2000"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"


class

	SQL_GENERATOR_TSQL2005


inherit

	SQL_GENERATOR_TSQL2000
		redefine
			target_name,
			conditional_drop_procedure
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "MS SQL Server 2005"
		end


feature -- Stored procedure support

	conditional_drop_procedure (name: STRING)
			-- Drop procedure, but only if it exists, should never
			-- generate an error or warning.
		do
			std.output.put_string ("drop procedure if exists ")
			std.output.put_line (quote_identifier (name))
			end_with_go
		end


end
