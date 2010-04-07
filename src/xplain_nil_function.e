indexing

	description: "Xplain any function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

class

	XPLAIN_NIL_FUNCTION

inherit

	XPLAIN_EXISTENTIAL_FUNCTION
		redefine
			is_nil,
			sqlextenddefault
		end


feature -- Status

	is_nil: BOOLEAN is True


feature -- Access

	name: STRING is "nil"
			-- Xplain name of function

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: XPLAIN_EXPRESSION): STRING is
			-- default to use for extension when function returns a Null value
		do
			Result := sqlgenerator.sqlfunction_any
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING is
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_nil
		end

end
