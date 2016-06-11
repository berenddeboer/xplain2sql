note

	description: "Xplain max function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

class

	XPLAIN_MAX_FUNCTION

inherit

	XPLAIN_FUNCTION
		redefine
			sqlextenddefault
		end


feature -- Status

	property_required: INTEGER = 1
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	name: STRING = "max"
			-- Xplain name of function

	representation (
			 sqlgenerator: SQL_GENERATOR;
			 type: XPLAIN_TYPE;
			 expression: detachable XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION
			-- The Xplain representation for this function
		do
				check
					need_expression: expression /= Void
				end
			Result := expression.representation (sqlgenerator)
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: detachable XPLAIN_EXPRESSION): STRING
			-- default to use for extension when function returns a Null value
		do
			Result := expression.sqlminvalue (sqlgenerator)
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_max
		end

end
