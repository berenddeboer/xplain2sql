indexing

	description: "Base for all expression types."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #14 $"

deferred class

	XPLAIN_EXPRESSION


feature -- Status

	can_be_null: BOOLEAN is
			-- Can the result of this expression be a Null value?
		do
			Result := False
		end

	has_wild_card_characters: BOOLEAN is
			-- Does the expression contain the Xplain wildcard characters
			-- '*' or '?'?
		do
			Result := False
		end

	is_constant: BOOLEAN is
			-- Is this expression a constant value?
			-- Expressions like 1 + 1, although technically a constant,
			-- are not considered constants, unless `sqlvalue'
			-- precalculates these expressions and returns it as a
			-- constant.
		do
			Result := False
		end

	is_literal: BOOLEAN is
			-- Is this a literal expression?
			-- A literal expressions only uses numbers or strings and
			-- could possible be an expression like "1 + 1".
		do
			Result := is_constant
		ensure
			consistent: is_constant implies Result
		end

	is_logical_constant: BOOLEAN is
			-- Is this the True or False constant?
		do
			Result := False
		ensure
			consistent: Result implies is_logical_expression
		end

	is_logical_expression: BOOLEAN is
			-- Is this a logical expression?
		do
			Result := False
		end

	is_specialization: BOOLEAN is
			-- Is this expression an attribute its list and does it refer
			-- to an attribute that is a specialization?
			-- Used for XML generation.
		once
			Result := False
		end

	is_string_expression: BOOLEAN is
			-- Is this a string?
		do
		end

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		require
			attribute_name_not_void: an_attribute /= Void
		do
			Result := not is_literal
		ensure
			literal_implies_no_other: is_literal implies not Result
		end

	selects_max_one_row: BOOLEAN is
			-- When this expression is used in a where clause, does it
			-- return max one row?
			-- Only useful when expression is a predicate of course.
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		require
			parameter_not_void: a_parameter /= Void
		deferred
		end


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
			join_list_not_void: join_list /= Void
		do
			-- do nothing
		end

	exact_representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Most exact representation of this expression, should not
			-- try to accomodate larger values.
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := representation (sqlgenerator)
		ensure
			valid_result: Result /= Void
		end

	column_name: STRING is
			-- The Xplain based column heading name, if any; it is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
			-- It seems very similar to `sqlname' so perhaps need these
			-- can be merged.
			-- Leave empty for complex expressions, in that case a higher
			-- level function should come up with something.
		do
		ensure
			result_is_void_or_not_empty: Result = Void or else not Result.is_empty
		end

	path_name: STRING is
			-- XML path name, keeping Xplain structure intact; user for
			-- path procedures
		do
			Result := column_name
		ensure
			result_is_void_or_not_empty: Result = Void or else not Result.is_empty
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Guessed representation that matches this expression;
			-- Used to generate representations for value and extend
			-- statements. As it must be able to accomodate updates, it
			-- is usually wider than required.
			-- Use `exact_representation' to get a more precise representation.
		require
			have_sqlgenerator: sqlgenerator /= Void
		deferred
		ensure
			valid_result: Result /= Void
			have_domain_restriction: Result.domain_restriction /= Void
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- an attribute of `a_type' it has to be prefixed by "new." for
			-- example.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sqlmaxvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return the maximum value of this expression according to its type.
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := representation (sqlgenerator).max_value (sqlgenerator)
		ensure
			min_value_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlminvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return the minimum value of this expression according to its type.
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := representation (sqlgenerator).min_value (sqlgenerator)
		ensure
			min_value_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlname (sqlgenerator: SQL_GENERATOR): STRING is
			-- Try to come up with the most likely column name for this
			-- expression, only applicable for attributes. If nothing
			-- found, return Void.
			-- Very similar to `column_name' so we return that as default.
		require
			have_sqlgenerator: sqlgenerator /= Void
		do
			Result := column_name
		ensure
			result_is_void_or_not_empty: Result = Void or else not Result.is_empty
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Expression in generator syntax
		require
			generator_not_void: sqlgenerator /= Void
		deferred
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	sqlvalue_as_wildcard (sqlgenerator: SQL_GENERATOR): STRING is
			-- As `sqlvalue', but a string literal uses this to return a
			-- properly formatted SQL like expression
		require
			generator_not_void: sqlgenerator /= Void
		do
			Result := sqlvalue (sqlgenerator)
		ensure
			not_empty: Result /= Void and then not Result.is_empty
		end

	outer_sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return expression in generator syntax.
			-- Same as `sqlvalue' but it may expect that it is not
			-- wrapped in another expression. So it may want to add
			-- additional brackets, converting the result (to a Boolean)
			-- etc.
		require
			generator_not_void: sqlgenerator /= Void
		do
			Result := sqlvalue (sqlgenerator)
		ensure
			valid_result: Result /= Void
		end

	sql_alias (sqlgenerator: SQL_GENERATOR): STRING is
			-- Used in `do_do_create_select_list' if output comes from an
			-- optimised extension and therefore doesn't have a nice
			-- colum name. With this the column name can be forced even
			-- if the user doesn't specify " as ".
			-- Void if not applicable.
		require
			sqlgenerator_not_void: sqlgenerator /= Void
		do
		end


end
