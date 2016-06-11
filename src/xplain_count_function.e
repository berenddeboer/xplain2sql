note

	description: "Xplain count function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"

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

	property_required: INTEGER = 2
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	name: STRING = "count"
			-- Xplain name of function

	needs_coalesce: BOOLEAN = False
			-- count never returns Nulls

	needs_distinct: BOOLEAN = True
			-- Does function need a distinct clause (count function)?

	representation (
			 sqlgenerator: SQL_GENERATOR;
			 type: XPLAIN_TYPE;
			 expression: detachable XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION
			-- What's the xplain representation for this function?
		do
			Result := sqlgenerator.value_representation_integer (9)
		end

	sqlextenddefault (sqlgenerator: SQL_GENERATOR; expression: detachable XPLAIN_EXPRESSION): STRING
			-- default to use for extension when function returns a Null value
		once
			Result := "0"
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING
			-- switch into correct sql function statement
		do
			Result := sqlgenerator.sqlfunction_count
		end

end
