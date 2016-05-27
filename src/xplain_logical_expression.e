note

	description: "Turns a logical expression into correct output for SQL dialects that don't support Booleans."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

class

	XPLAIN_LOGICAL_EXPRESSION


inherit

	XPLAIN_WRAPPED_EXPRESSION
		redefine
			is_logical_expression,
			outer_sqlvalue,
			sqlvalue
		end


create

	make



feature -- Status

	is_logical_expression: BOOLEAN = True


feature -- SQL generation

	outer_sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return expression in generator syntax.
			-- Same as `sqlvalue' but it may expect that it is not
			-- wrapped in another expression.
		do
			if expression.is_logical_expression then
				Result := sqlgenerator.sql_expression_as_boolean_value (expression)
			else
				Result := expression.outer_sqlvalue (sqlgenerator)
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		do
			-- A logical expression is not always a Boolean, due to
			-- parser issues. Might need to do away with trying to do so
			-- much semantics in the parser, and do the semantics in a
			-- later step. Might clean up things and remove my parser
			-- shift and reduce issues.
			-- So that's why we return the representation of the wrapped
			-- expression, and not just that it is a Boolean.
			Result := expression.representation (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
		do
			Result := expression.sqlvalue (sqlgenerator)
		end


end
