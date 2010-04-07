indexing

  description: "not expression. Has to be treated specially for dialects that don't have a True Boolean"
  author:     "Berend de Boer <berend@pobox.com>"
  copyright:  "Copyright (c) 2003, Berend de Boer"
  date:       "$Date: 2008/12/15 $"
  revision:   "$Revision: #3 $"

class

	XPLAIN_NOT_EXPRESSION

inherit

	XPLAIN_PREFIX_EXPRESSION
		rename
			make as make_prefix_expression
		redefine
			add_to_join,
			sqlvalue
		end


create

	make


feature -- Initialization

	make (an_operand: XPLAIN_EXPRESSION) is
		require
			valid_operand: an_operand /= Void
		do
			operand := an_operand
			operator := once_not
		end


feature -- SQL generation

	add_to_join (sqlgenerator: SQL_GENERATOR; join_list: JOIN_LIST) is
			-- Possibility of expression to add something to join part of
			-- a select statement.
		do
			join_list.disable_existential_join_optimisation
			operand.add_to_join (sqlgenerator, join_list)
			join_list.enable_existential_join_optimisation
		end

	sqlvalue (sqlgenerator: SQL_GENERATOR): STRING is
			-- Return expression in generator syntax.
		do
			Result := sqlgenerator.sql_not_expression (operand)
		end


feature {NONE} -- Implementation

	once_not: STRING is "not"

end
