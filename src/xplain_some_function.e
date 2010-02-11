indexing

	description: "Xplain some function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #8 $"

class

	XPLAIN_SOME_FUNCTION

inherit

	XPLAIN_FUNCTION
		redefine
			is_some,
			needs_coalesce,
			needs_limit
		end


feature -- Status

	is_some: BOOLEAN is True

	property_required: INTEGER is 2
			-- Does function need the presence of a property?
			-- 0: forbidden; 1: must be presented; 2: don't care either way


feature -- Access

	name: STRING is "some"
			-- Xplain name of function

	needs_coalesce: BOOLEAN is False
			-- it's ok for some to return a Null.

	needs_limit (sqlgenerator: SQL_GENERATOR): BOOLEAN is
			-- Can the function return more than one value, so we need to
			-- top it off?
		do
			Result := True
		end

	representation (
			 sqlgenerator: SQL_GENERATOR;
			 type: XPLAIN_TYPE;
			 expression: XPLAIN_EXPRESSION): XPLAIN_REPRESENTATION is
			-- The xplain representation for this function
		do
			if expression = Void then
				Result := type.representation
			else
				Result := expression.representation (sqlgenerator)
			end
		end

	sqlfunction (sqlgenerator: SQL_GENERATOR): STRING is
			-- The SQL equivalent for for this function
		do
			Result := sqlgenerator.sqlfunction_some
		end


invariant

	some_function: is_some

end
