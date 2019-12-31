note

	description: "Xplain expression that is a function with two operands. This class is a base class for the actual functions like '+' or 'combine'"
	author:     "Berend de Boer <berend@pobox.com>"


deferred class

	XPLAIN_TWO_OPERANDS_FUNCTION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			has_wild_card_characters,
			is_literal,
			is_using_other_attributes
		end


feature {NONE} -- Initialization

	make (a_left, a_right: XPLAIN_EXPRESSION)
		require
			left_not_void: a_left /= Void
			right_not_void: a_right /= Void
		do
			left := a_left
			right := a_right
		end


feature -- Access

	left,
	right: XPLAIN_EXPRESSION
			-- Left and right operand

	name: STRING
			-- Xplain function name or operator
		deferred
		ensure
			name_not_empty: Result /= Void and then not name.is_empty
		end


feature -- Status

	has_wild_card_characters: BOOLEAN
			-- Does the expression contain the Xplain wildcard characters
			-- '*' or '?'?
		do
			Result := left.has_wild_card_characters or else right.has_wild_card_characters
		end

	is_literal: BOOLEAN
		do
			Result := left.is_literal and then right.is_literal
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result :=
				right.is_using_other_attributes (an_attribute) or else
				left.is_using_other_attributes (an_attribute)
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := left.uses_its or else right.uses_its
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result :=
				right.uses_parameter (a_parameter) or else
				left.uses_parameter (a_parameter)
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			left.add_to_join (sqlgenerator, join_list)
			right.add_to_join (sqlgenerator, join_list)
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- The representation of left operand. Maybe should be
			-- improved to infer better? Did work for this in
			-- XPLAIN_INFIX_EXPRESSION.
		do
			Result := left.representation (sqlgenerator)
		end


invariant

	left_not_void: left /= Void
	right_not_void: right /= Void


end
