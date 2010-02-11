indexing

	description: "Extension definition that is an expression, not a function"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #8 $"


class

	XPLAIN_EXTENSION_EXPRESSION_EXPRESSION

inherit

	XPLAIN_EXTENSION_EXPRESSION
		rename
			make as inherited_make
		redefine
			add_to_join,
			is_literal,
			is_update_optimization_supported,
			representation,
			sqlselect,
			sqlvalue,
			outer_sqlvalue,
			uses_non_data_attributes,
			uses_parameter
		end

create

	make

feature {NONE} -- Initialization

	make (an_expression: XPLAIN_EXPRESSION) is
		require
			valid_expression: an_expression /= Void
		do
			expression := an_expression
		end

feature -- Access

	expression: XPLAIN_EXPRESSION


feature -- Status

	is_literal: BOOLEAN is
		do
			Result := expression.is_literal
		end

	is_update_optimization_supported: BOOLEAN is True
			-- Is this an extension that will benefit from optimized
			-- output in case it is not used in updates?

	uses_non_data_attributes: BOOLEAN is
			-- Does this extension expression use attributes of its owner
			-- that are other assertions or does it use an its list?
		do
			-- TODO: implement proper check, now it generates incorrect
			-- assertion code when its list present.
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := expression.uses_parameter (a_parameter)
		end


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			expression.add_to_join (sqlgenerator, join_list)
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- Return correct representation for this expression.
		do
			Result := expression.representation (sqlgenerator)
		end

	sqlselect (sqlgenerator: SQL_GENERATOR; an_extension: XPLAIN_EXTENSION): STRING is
			-- SQL for the full select statement that emits the data used
			-- to create extension.
		do
			Result := sqlgenerator.sql_select_for_extension_expression (Current)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- The extension expression converted to SQL
		do
			Result := expression.sqlvalue (sqlgenerator)
		end

	outer_sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return expression in generator syntax.
			-- Same as `sqlvalue' but it may expect that it is not
			-- wrapped in another expression. So it may want to add
			-- additional brackets, converting the result (to a Boolean)
			-- etc.
		do
			Result := expression.outer_sqlvalue (sqlgenerator)
		end


invariant

	valid_expression: expression /= Void

end
