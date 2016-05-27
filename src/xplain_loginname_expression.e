note

	description: "loginname variable expression"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2000, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #3 $"

class

	XPLAIN_LOGINNAME_EXPRESSION

inherit

	XPLAIN_SYSTEM_EXPRESSION
		redefine
			column_name
		end

feature

	column_name: STRING
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		once
			Result := "login name"
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
		do
			Result := sqlgenerator.value_representation_system_user
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
		do
			Result := sqlgenerator.sqlsysfunction_system_user
		end

end
