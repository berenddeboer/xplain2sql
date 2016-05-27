note

	description: "Conversion of expression to a string."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #5 $"


class

	XPLAIN_STRING_FUNCTION


inherit

	XPLAIN_ONE_OPERAND_FUNCTION
		redefine
			is_string_expression,
			representation
		end


create

	make


feature -- Access

	name: STRING = "string"


feature -- Status

	is_string_expression: BOOLEAN = True
			-- Is this a string?


feature -- SQL code

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
			Result := sqlgenerator.value_representation_char (250)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression which casts `operand' to a string
		do
			Result := sqlgenerator.sql_init_cast_to_string (operand)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Expression which casts `operand' to a string
		do
			Result := sqlgenerator.sql_cast_to_string (operand)
		end


end
