note

	description: "Value of a value being used in an expression"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #10 $"

class

	XPLAIN_VALUE_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			column_name,
			is_literal
		end


create

	make


feature {NONE} -- Initialization

	make (a_value: XPLAIN_VALUE)
		require
			valid_value: a_value /= Void
		do
			value := a_value
		end


feature -- Access

	value: XPLAIN_VALUE
			-- The value


feature -- Status

	is_literal: BOOLEAN
		do
			Result := value.expression.is_literal
		end

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := value.expression.uses_its
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := value.expression.uses_parameter (a_parameter)
		end


feature -- SQL specifics

	column_name: STRING
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		do
			Result := value.name
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Return correct representation for this expression.
			-- Used to generate representations for value and extend statements.
		do
			Result := value.representation
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- SQL to return the contents of a value
		do
			Result := sqlgenerator.sqlgetvalue (value)
		end


invariant

	value_not_void: value /= Void

end
