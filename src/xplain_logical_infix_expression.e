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
			add_to_join,
			is_logical_expression,
			representation
		end

	KL_IMPORTED_STRING_ROUTINES
		export
			{NONE} all
		end


create

	make


feature -- Status

	is_logical_expression: BOOLEAN is True


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		local
			or_operator: BOOLEAN
		do
			or_operator := STRING_.same_string (operator, once "or")
			if or_operator then
				join_list.disable_existential_join_optimisation
			end
			precursor (sqlgenerator, join_list)
			if or_operator then
				join_list.enable_existential_join_optimisation
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		do
			Result := sqlgenerator.value_representation_boolean
		end


end
