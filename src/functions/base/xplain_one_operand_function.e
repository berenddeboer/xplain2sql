note

	description: "Xplain expression that is a function with a single operand."
	author:     "Berend de Boer <berend@pobox.com>"


deferred class

	XPLAIN_ONE_OPERAND_FUNCTION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			column_name,
			is_using_other_attributes
		end


feature {NONE} -- Initialization

	make (an_operand: XPLAIN_EXPRESSION)
			-- Initialize.
		require
			operand_not_void: an_operand /= Void
		do
			operand := an_operand
		end


feature -- Access

	column_name: detachable STRING
			-- Try to come up with the most likely column name for this
			-- expression, only applicable for attributes. If nothing
			-- found, return Void.
		do
			Result := operand.column_name
		end

	operand: XPLAIN_EXPRESSION

	name: STRING
			-- Xplain function name or operator
		deferred
		ensure
			name_not_empty: Result /= Void and then not name.is_empty
		end


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result := operand.is_using_other_attributes (an_attribute)
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := operand.uses_parameter (a_parameter)
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := operand.uses_its
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			operand.add_to_join (sqlgenerator, join_list)
		end

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
			Result := operand.representation (sqlgenerator)
		end


invariant

	operand_not_void: operand /= Void

end
