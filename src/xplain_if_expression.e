indexing

	description:

		"Captures an if ... then ... else expression"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2005, Berend de Boer and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008/12/15 $"
	revision: "$Revision: #6 $"


class

	XPLAIN_IF_EXPRESSION


inherit

	XPLAIN_EXPRESSION
		redefine
			is_using_other_attributes,
			sqlinitvalue,
			add_to_join
		end


create

	make


feature {NONE} -- Initialization

	make (a_condition: XPLAIN_LOGICAL_EXPRESSION; a_then_specification, an_else_specification: XPLAIN_EXPRESSION) is
			-- Initialization.
		require
			condition_not_void: a_condition /= Void
			then_specification_not_void: a_then_specification /= Void
			else_specification_not_void: an_else_specification /= Void
		do
			condition := a_condition
			then_specification := a_then_specification
			else_specification := an_else_specification
		end


feature -- Access

	condition: XPLAIN_LOGICAL_EXPRESSION
			-- If condition

	then_specification: XPLAIN_EXPRESSION
		-- Value when `condition'

	else_specification: XPLAIN_EXPRESSION
		-- Value when not `condition'


feature -- Status

	is_using_other_attributes (an_attribute: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to other attributes as `an_attribute'?
			-- It is used to output better optimized SQL code.
		do
			Result :=
				condition.is_using_other_attributes (an_attribute) or else
				then_specification.is_using_other_attributes (an_attribute) or else
				else_specification.is_using_other_attributes (an_attribute)
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result :=
				condition.uses_parameter (a_parameter) or else
				then_specification.uses_parameter (a_parameter) or else
				else_specification.uses_parameter (a_parameter)
		end


feature -- SQL code

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			condition.add_to_join (sqlgenerator, join_list)
			then_specification.add_to_join (sqlgenerator, join_list)
			else_specification.add_to_join (sqlgenerator, join_list)
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Guessed representation that matches this expression.
			-- Used to generate representations for value and extend
			-- statements. As it must be able to accomodate updates, it
			-- is usually wider than required.
			-- Use `exact_reprsentation' to get a more precise representation.
		do
			Result := then_specification.representation (sqlgenerator)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Return expression in sql syntax used in init statements.
		do
			Result := sqlgenerator.sqlinitvalue_if (Current)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Expression in generator syntax
		do
			Result := "case when " + condition.sqlvalue (sqlgenerator) + " then " + then_specification.sqlvalue (sqlgenerator) + " else " + else_specification.sqlvalue (sqlgenerator) + " end"
		end


invariant

	condition_not_void: condition /= Void
	then_specification_not_void: then_specification /= Void
	else_specification_not_void: else_specification /= Void

end
