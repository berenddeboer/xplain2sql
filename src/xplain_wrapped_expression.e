note

	description: "Expression that wraps another expression. Does some default behaviour to operate correctly in such cases."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #6 $"

deferred class

	XPLAIN_WRAPPED_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			add_to_join,
			column_name,
			is_constant,
			is_literal,
			is_logical_constant,
			is_logical_expression,
			is_using_other_attributes,
			sqlname
		end


feature {NONE} -- Initialization

	make (a_expression: XPLAIN_EXPRESSION)
		require
			expression_not_void: a_expression /= Void
		do
			expression := a_expression
		end


feature -- Status

	is_constant: BOOLEAN
		do
			Result := expression.is_constant
		end

	is_literal: BOOLEAN
			-- Is this a literal expression?
		do
			Result := expression.is_literal
		end

	is_logical_constant: BOOLEAN
			-- Is this the True or False constant?
		do
			Result := expression.is_logical_constant
		end

	is_logical_expression: BOOLEAN
			-- Is this a logical expression?
		do
			Result := expression.is_logical_expression
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result := expression.is_using_other_attributes (an_attribute)
		end

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


feature -- Access

	expression: XPLAIN_EXPRESSION
			-- The wrapped expression


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST)
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			expression.add_to_join (sqlgenerator, join_list)
		end

	column_name: STRING
			-- The Xplain based column heading name, if any. It is used
			-- by XML_GENERATOR to give clients some idea what the column
			-- name of a select is going to be.
		do
			Result := expression.column_name
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING
			-- Try to come up with the most likely column name for this
			-- expression, only applicable for attributes. If nothing
			-- found, return Void.
		do
			Result := expression.sqlname (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- attributes of the type it has to be prefixed by "new." for
			-- example.
		do
			Result := expression.sqlinitvalue (sqlgenerator)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Return expression in generator syntax.
		do
			Result := expression.sqlvalue (sqlgenerator)
		end


invariant

	expression_not_void: expression /= Void

end
