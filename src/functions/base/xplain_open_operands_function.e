indexing

	description: "Xplain expression that is a function with one or more operands."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #2 $"


deferred class

	XPLAIN_OPEN_OPERANDS_FUNCTION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			has_wild_card_characters,
			is_literal,
			is_using_other_attributes
		end


feature {NONE} -- Initialization

	make (an_operands: XPLAIN_EXPRESSION_NODE) is
		require
			operands_not_void: an_operands /= Void
		do
			operands := an_operands
		end


feature -- Access

	operands: XPLAIN_EXPRESSION_NODE
			-- Operands

	name: STRING is
			-- Xplain function name or operator
		deferred
		ensure
			name_not_empty: Result /= Void and then not name.is_empty
		end


feature -- Status

	has_wild_card_characters: BOOLEAN is
			-- Does the expression contain the Xplain wildcard characters
			-- '*' or '?'?
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void or else Result
			loop
				Result := n.item.has_wild_card_characters
				n := n.next
			end
		end

	is_literal: BOOLEAN is
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void or else Result
			loop
				Result := n.item.is_literal
				n := n.next
			end
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void or else Result
			loop
				Result := n.item.is_using_other_attributes (an_attribute)
				n := n.next
			end
		end

	uses_its: BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void or else Result
			loop
				Result := n.item.uses_its
				n := n.next
			end
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void or else Result
			loop
				Result := n.item.uses_parameter (a_parameter)
				n := n.next
			end
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		local
			n: XPLAIN_EXPRESSION_NODE
		do
			from
				n := operands
			until
				n = Void
			loop
				n.item.add_to_join (sqlgenerator, join_list)
				n := n.next
			end
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- The representation of left operand. Maybe should be
			-- improved to infer better? If you add int and double, should
			-- return double I think.
			-- Also I think we should return a type that is equal to the
			-- types involved. A division is always an integer division
			-- if both types are integer. Cast a type to a double to get
			-- a double result. Anyway, this is what PostgreSQL seems to
			-- be doing.
		do
			Result := operands.item.representation (sqlgenerator)
		end


invariant

	operands_not_void: operands /= Void


end
