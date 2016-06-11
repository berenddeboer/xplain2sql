note

	description: "Xplain any function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_ANY_FUNCTION


inherit

	XPLAIN_EXISTENTIAL_FUNCTION
		redefine
			sqlextenddefault
		end


feature -- Access

	name: STRING = "any"
			-- Xplain name of function

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: detachable XPLAIN_EXPRESSION): STRING
			-- default to use for extension when function returns a Null value
		do
			Result := sqlgenerator.sqlfunction_nil
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_any
		end

end
