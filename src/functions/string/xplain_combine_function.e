note

	description: "Concatenation of two strings."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2004, Berend de Boer"
	date:       "$Date: 2008/12/15 $"
	revision:   "$Revision: #4 $"

class

	XPLAIN_COMBINE_FUNCTION


inherit

	XPLAIN_OPEN_OPERANDS_FUNCTION
		rename
			name as operator
		redefine
			is_string_expression,
			sqlvalue_as_wildcard
		end


create

	make


feature -- Access

	operator: STRING = "+"


feature -- Status

	is_string_expression: BOOLEAN = True
			-- Is this a string?


feature -- SQL code

	sqloperator: STRING
			-- The SQL translation for `operator'
		do
			Result := operator
		ensure
			sql_operator_not_empty: Result /= Void and then not Result.is_empty
		end

	sqlinitvalue (sqlgenerator: SQL_GENERATOR_WITH_TRIGGERS): STRING
			-- Expression in sql syntax used in init statements. Equal to
			-- `sqlvalue' in many cases, but usually if you refer to
			-- an attribute of `a_type' it has to be prefixed by "new." for
			-- example.
		do
			Result := sqlgenerator.sql_init_combine_expression (operands)
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Expression in generator syntax
		local
			s: STRING
		do
			s := sqlgenerator.sql_combine_expression (operands)
			create Result.make (2 + s.count)
			Result.append_character ('(')
			Result.append_string (s)
			Result.append_character (')')
		end

	sqlvalue_as_wildcard (sqlgenerator: SQL_GENERATOR): STRING
			-- As `sqlvalue', but a string literal uses this to return a
			-- properly formatted SQL like expression
		local
			s: STRING
		do
			s := sqlgenerator.sql_combine_expression_as_wildcard (operands)
			create Result.make (2 + s.count)
			Result.append_character ('(')
			Result.append_string (s)
			Result.append_character (')')
		end


end
