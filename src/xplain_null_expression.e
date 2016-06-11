note

	description: "Xplain base class for comparison to NULL expression."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"


deferred class

	XPLAIN_NULL_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join
		end


feature {NONE} -- Initialization

	make (a_expression: XPLAIN_EXPRESSION)
			-- Initialize.
		require
			a_expression_not_void: a_expression /= Void
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end


feature -- Access

	expression: XPLAIN_EXPRESSION
			-- Property that is compared to Null.


feature -- Status

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := expression.uses_its
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := expression.uses_parameter (a_parameter)
		end


feature -- SQL specifics

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			expression.add_to_join (sqlgenerator, join_list)
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		local
			restriction: XPLAIN_REQUIRED
		do
			-- The result of comparing to null is a boolean
			create {XPLAIN_B_REPRESENTATION} Result
			create restriction.make (False)
			Result.set_domain_restriction (sqlgenerator, restriction)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			Result :=
				expression.sqlinitvalue (sqlgenerator) + compare_with_null
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return expression in generator syntax.
		do
			Result :=
				expression.sqlvalue (sqlgenerator) + compare_with_null
		end


feature {NONE} -- Implementation

	compare_with_null: STRING
			-- The string which compares a property with NULL.
		deferred
		ensure
			compare_with_null_not_empty: compare_with_null /= Void and then not compare_with_null.is_empty
		end


invariant

	expression_not_void: expression /= Void

end
