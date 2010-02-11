indexing

	description: "use for prefix expressions like not or -"
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 1999, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #7 $"

class

	XPLAIN_PREFIX_EXPRESSION

inherit

	XPLAIN_ONE_OPERAND_FUNCTION
		rename
			name as operator,
			make as make_one_operand
		redefine
			sqlvalue
		end


create

	make


feature -- Initialization

	make (an_operator: STRING;
			an_operand: XPLAIN_EXPRESSION) is
		require
			valid_operator: an_operator /= Void and then not an_operator.is_empty
			valid_operand: an_operand /= Void
		do
			operator := an_operator
			make_one_operand (an_operand)
		end


feature -- Access

	operator: STRING


feature -- SQL generation

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING is
			-- Expression which casts `operand' to a string
		do
			Result :=
				"( " +
				operator + " " +
				operand.sqlinitvalue (sqlgenerator) +
				" )"
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return expression in generator syntax.
		do
			Result :=
				operator + " " +
				"( " +
				operand.sqlvalue (sqlgenerator) +
				" )"
		end


invariant

	operator_not_empty: operator /= Void and then not operator.is_empty

end
