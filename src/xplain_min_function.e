indexing

	description: "Xplain min function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #5 $"

class

	XPLAIN_MIN_FUNCTION

inherit

	XPLAIN_FUNCTION
		redefine
			sqlextenddefault
		end


feature -- Status

	property_required: INTEGER is 1
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	name: STRING is "min"
			-- Xplain name of function

	representation (
			sqlgenerator: SQL_GENERATOR;
			type: XPLAIN_TYPE;
			expression: XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION is
			-- What's the xplain representation for this function?
		do
				check
					need_expression: expression /= Void
				end
			Result := expression.representation (sqlgenerator)
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: XPLAIN_EXPRESSION): STRING is
			-- default to use for extension when function returns a Null value
		do
			Result := expression.sqlmaxvalue (sqlgenerator)
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING is
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_min
		end

end
