note

	description:

		"Expression that surrounds another expression with explicit parenthesis"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2006, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #4 $"


class

	XPLAIN_PARENTHESIS_EXPRESSION


inherit

	XPLAIN_WRAPPED_EXPRESSION
		redefine
			sqlinitvalue,
			sqlvalue
		end


create

	make


feature -- Access

	name: STRING = "()"


feature -- SQL code

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- The representation of left operand. Maybe should be
			-- improved to infer better? If you add int and double, should
			-- return double I think.
			-- Also I think we should return a type that is equal to the
			-- types involved. A division is always an integer division
			-- if both types are integer. Cast a type to a double to get
			-- a double result. Anyway, this is what PostgreSQL seems to
			-- be doing.
		do
			Result := expression.representation (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			if expression.is_constant then
				Result := expression.sqlvalue (sqlgenerator)
			else
				Result := "(" + expression.sqlinitvalue (sqlgenerator) + ")"
			end
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return string.
		do
			if expression.is_constant then
				Result := expression.sqlvalue (sqlgenerator)
			else
				Result := "(" + expression.sqlvalue (sqlgenerator) + ")"
			end
		end


end
