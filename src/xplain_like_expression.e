note

	description: "Use for = with a string literal that has wild card characters. Perhaps I will introduce a real like operator as well."
	author:     "Berend de Boer <berend@pobox.com>"
	copyright:  "Copyright (c) 2003, Berend de Boer"
	date:       "$Date: 2010/02/11 $"
	revision:   "$Revision: #4 $"


class

	XPLAIN_LIKE_EXPRESSION


inherit

	XPLAIN_INFIX_EXPRESSION
		rename
			make as make_infix
		redefine
			sqloperator,
			sqlvalue
		end


create

	make


feature {NONE} -- Initialization

	make (
			a_left: XPLAIN_EXPRESSION;
			a_right: XPLAIN_EXPRESSION)
		require
			valid_left: a_left /= Void
			valid_right: a_right /= Void
		local
		do
			make_infix (a_left, xplain_operator, a_right)
		end


feature -- SQL code

	sqloperator: STRING
			-- The SQL translation for `operator'
		once
			Result := "like"
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING
			-- Value as SQL expression
		local
			left_value,
			right_value: STRING
			my_operator: STRING
		do
			my_operator := sqlgenerator.sql_like_operator
			left_value := left.sqlvalue_as_wildcard (sqlgenerator)
			right_value := right.sqlvalue_as_wildcard (sqlgenerator)
			create Result.make (left_value.count + 1 + my_operator.count + 1 + right_value.count)
			Result.append_string (left_value)
			Result.append_character (' ')
			Result.append_string (my_operator)
			Result.append_character (' ')
			Result.append_string (right_value)
		end


feature {NONE} -- Once strings

	xplain_operator: STRING
			-- The Xplain operator itself.
		once
			Result := "="
		ensure
			xplain_operator_not_empty: Result /= Void and then not Result.is_empty
		end


end
