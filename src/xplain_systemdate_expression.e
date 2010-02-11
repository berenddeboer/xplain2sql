indexing

	description: "systemdate variable expression"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"

class

	XPLAIN_SYSTEMDATE_EXPRESSION

inherit

	XPLAIN_SYSTEM_EXPRESSION
		redefine
			column_name
		end

feature -- SQL output

	column_name: STRING is
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		once
			Result := "system date"
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_current_timestamp
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
		do
			Result := sqlgenerator.sqlsysfunction_current_timestamp
		end

end
