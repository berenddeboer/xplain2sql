indexing

	description: "Xplain count function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

class

	XPLAIN_COUNT_FUNCTION

inherit

	XPLAIN_FUNCTION
		redefine
			needs_coalesce,
			needs_distinct,
			sqlextenddefault
		end


feature -- Status

	property_required: INTEGER is 2
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	name: STRING is "count"
			-- Xplain name of function

	needs_coalesce: BOOLEAN is False
			-- count never returns Nulls

	needs_distinct: BOOLEAN is True
			-- Does function need a distinct clause (count function)?

	representation (
			 sqlgenerator: SQL_GENERATOR;
			 type: XPLAIN_TYPE;
			 expression: XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION is
			-- What's the xplain representation for this function?
		do
			Result := sqlgenerator.value_representation_integer (9)
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: XPLAIN_EXPRESSION): STRING is
			-- default to use for extension when function returns a Null value
		once
			Result := "0"
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING is
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_count
		end

end
