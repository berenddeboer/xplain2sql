indexing

	description: "Produces mySQL 4.0 output. Assumes running in ANSI mode!"

	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2001, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"


class

	SQL_GENERATOR_MYSQL4


inherit

	SQL_GENERATOR_MYSQL
		redefine
			AutoPrimaryKeyConstraint,
			create_use_database,
			drop_table_if_exist,
			quote_identifier
		end


create

	make


feature -- About this generator

	target_name: STRING is
			-- Name and version of dialect
		once
			Result := "mySQL 4.0, ANSI mode"
		end

feature -- table options

	AutoPrimaryKeyConstraint: STRING is
		once
			Result := "identity " + PrimaryKeyConstraint
		end


feature -- SQL creation statements

	create_use_database (database: STRING) is
			-- start using a certain database
		do
			write_one_line_comment ("This script assumes ANSI SQL mode has been enabled.")
		end


feature -- Drop statements, should fail gracefully if things are not supported

	drop_table_if_exist (type: XPLAIN_TYPE) is
			-- Generate a statement that drops this table, but only if it exists,
			-- No warning must be generated if the table does not exist at
			-- run-time
		do
			std.output.put_string ("drop table if exists ")
			std.output.put_string (quote_identifier (type.sqltablename (Current)))
			std.output.put_string (CommandSeparator)
			std.output.put_character ('%N')
		end


feature -- identifiers

	quote_identifier (identifier: STRING): STRING is
			-- return identifier, optionally surrounded by quotes if identifier
			-- contains spaces and rdbms supports spaces in identifiers
		do
			create Result.make (identifier.count + 2)
			Result.append_character ('"')
			Result.append_string (identifier)
			Result.append_character ('"')
		end

end
