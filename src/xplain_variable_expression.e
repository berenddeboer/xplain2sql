note

	description: "Describes a constant (previous variable) being used in an expression"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #10 $"

class

	XPLAIN_VARIABLE_EXPRESSION

inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			column_name
		end

create

	make

feature {NONE} -- Initialization

	make (avariable: XPLAIN_VARIABLE)
		require
			valid_variable: avariable /= Void
		do
			variable := avariable
		end


feature -- Access

	variable: XPLAIN_VARIABLE


feature -- Generator independent qualities

	uses_its: BOOLEAN
			-- Does expression has an its list somewhere?
		do
			Result := False
		end

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL specifics

	column_name: STRING
			-- The Xplain based column heading name, if any. It is used
			-- by PostgreSQL output to create the proper function type
			-- for example. The XML_GENERATOR uses it to give clients
			-- some idea what the column name of a select is going to be.
		do
			Result := variable.name
		end

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION
			-- Representation is variable representation.
		do
			Result := variable.representation.value_representation (sqlgenerator)
		end

	sqlvalue (mygenerator: SQL_GENERATOR): STRING
			-- Return string.
		do
			Result := mygenerator.sqlgetconstant (variable)
		end

invariant

	variable_not_void: variable /= Void

end
