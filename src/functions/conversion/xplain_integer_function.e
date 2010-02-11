indexing

	description: "Conversion of expression to an integer."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"


class

	XPLAIN_INTEGER_FUNCTION


inherit

	XPLAIN_ONE_OPERAND_FUNCTION
		redefine
			representation
		end


create

	make


feature -- Access

	name: STRING is "integer"


feature -- SQL code

	representation (sqlgenerator: SQL_GENERATOR): XPLAIN_REPRESENTATION is
			-- The representation of left operand. Maybe should be
			-- improved to infer better? If you add int and double, should
			-- return double I think.
			-- Also I think we should return a type that is equal to the
			-- types involved. A division is always an integer division
			-- if both types are integer. Cast a type to a double to get
			-- a double result. Anyway, this is what PostgreSQL seems to
			-- be doing.
		do
			Result := sqlgenerator.value_representation_integer (9)
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression which casts `operand' to a string
		do
			Result := sqlgenerator.sql_init_cast_to_integer (operand)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Expression which casts `operand' to an integer
		do
			Result := sqlgenerator.sql_cast_to_integer (operand)
		end


end
