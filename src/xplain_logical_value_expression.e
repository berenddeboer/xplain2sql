indexing

	description: "Use for True/False values"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #9 $"

class

	XPLAIN_LOGICAL_VALUE_EXPRESSION


inherit

	XPLAIN_NON_ATTRIBUTE_EXPRESSION
		redefine
			is_constant,
			is_logical_constant,
			is_logical_expression
		end


create

	make


feature {NONE} -- Initialization

	make (a_value: BOOLEAN) is
		do
			value := a_value
		ensure
			value_set: value = a_value
		end


feature -- Access

	value: BOOLEAN


feature -- Status

	is_constant: BOOLEAN is True
			-- Is this expression a constant value?

	is_logical_constant: BOOLEAN is True
			-- Is this the True or False constant?

	is_logical_expression: BOOLEAN is True
			-- Is this a logical expression?

	uses_parameter (a_parameter: XPLAIN_ATTRIBUTE_NAME): BOOLEAN is
			-- Does this expression refer to `a_parameter'?
		do
			Result := False
		end


feature -- SQL generation

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
		do
			Result := sqlgenerator.value_representation_boolean
		end

	sqlvalue (mygenerator: SQL_GENERATOR): STRING is
			-- Return string.
		do
			if value then
				Result := mygenerator.SQLTrue
			else
				Result := mygenerator.SQLFalse
			end
		end

end
