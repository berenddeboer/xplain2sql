note

	description:

		"Produces output for FireBird 2.1"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #2 $"


class

	SQL_GENERATOR_FIREBIRD_21


inherit

	SQL_GENERATOR_INTERBASE6
		redefine
			SQLCoalesce,
			create_table,
			create_extend_create_index,
			sql_create_generator,
			target_name,
			TemporaryTablesSupported,
			CreateTemporaryTableStatement,
			FinishTemporaryTableStatement
		end


create

	make


feature -- About this generator

	target_name: STRING
			-- Name and version of dialect
		once
			Result := "FireBird 2.1"
		end


feature -- Coalesce

	SQLCoalesce: STRING
		once
			Result := "coalesce"
		end


feature -- Temporary tables

	TemporaryTablesSupported: BOOLEAN = True
			-- Does this dialect support the 'create temporary table'?

	CreateTemporaryTableStatement: STRING
			-- The create statement to start creating a temporary table.
		once
			if TemporaryTablesSupported then
				Result := "create global temporary table"
			else
				Result := "create table"
			end
		end

	FinishTemporaryTableStatement: STRING = "on commit preserve rows"


feature -- Sequences

	sql_create_generator: STRING = "create sequence"


feature -- Extends

	create_table (type: XPLAIN_TYPE)
		do
			precursor (type)
			commit
		end

	create_extend_create_index (an_extension: XPLAIN_EXTENSION)
		do
			commit
			precursor (an_extension)
		end


feature {NONE} -- SQL

	commit
		do
			std.output.put_string (once "commit")
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end

end
