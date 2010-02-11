indexing

	description:

		"Infix expression that uses a logical operator like or/and or = and <>"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2008-2009, Berend de Boer"
	license: "Eiffel Forum License v2 (see forum.txt)"


class

	XPLAIN_LOGICAL_INFIX_EXPRESSION


inherit

	XPLAIN_INFIX_EXPRESSION
		redefine
			is_logical_expression,
			representation
		end


create

	make


feature -- Status

	is_logical_expression: BOOLEAN is True


feature -- SQL generation

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		do
			Result := sqlgenerator.value_representation_boolean
		end


end
